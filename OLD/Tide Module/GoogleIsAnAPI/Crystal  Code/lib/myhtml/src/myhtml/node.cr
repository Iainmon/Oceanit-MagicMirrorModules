struct Myhtml::Node
  # :nodoc:
  getter parser : Parser

  # :nodoc:
  getter raw_node : Lib::MyhtmlTreeNodeT*

  # :nodoc:
  @attributes : Hash(String, String)?

  def self.from_raw(parser, raw_node)
    Node.new(parser, raw_node) unless raw_node.null?
  end

  def initialize(@parser, @raw_node)
  end

  #
  # Tag ID
  #   node.tag_id => Myhtml::Lib::MyhtmlTags::MyHTML_TAG_DIV
  #
  @[AlwaysInline]
  def tag_id : Lib::MyhtmlTags
    Lib.node_tag_id(@raw_node)
  end

  #
  # Tag Symbol
  #   node.tag_sym => :div
  #
  @[AlwaysInline]
  def tag_sym : Symbol
    Utils::TagConverter.id_to_sym(tag_id)
  end

  #
  # Tag Name
  #   node.tag_name => "div"
  #
  def tag_name : String
    String.new(tag_name_slice)
  end

  @[AlwaysInline]
  def tag_name_slice
    buffer = Lib.tag_name_by_id(@parser.@raw_tree, self.tag_id, out length)
    Slice.new(buffer, length)
  end

  #
  # Tag Text
  #   Direct text content of node
  #   present only on MyHTML_TAG__TEXT, MyHTML_TAG_STYLE, MyHTML_TAG__COMMENT nodes (node.textable?)
  #   for other nodes, you should call `inner_text` method
  #
  def tag_text
    String.new(tag_text_slice)
  end

  @[AlwaysInline]
  def tag_text_slice
    buffer = Lib.node_text(@raw_node, out length)
    Slice.new(buffer, length)
  end

  def tag_text_set(text : String, encoding = nil)
    raise ArgumentError.new("#{self.inspect} not allowed to set text") unless textable?
    Lib.node_text_set_with_charef(@raw_node, text.to_unsafe, text.bytesize, encoding || @parser.encoding)
  end

  #
  # Node Storage
  #   set Void* data related to this node
  #
  def data=(d : Void*)
    Lib.node_set_data(@raw_node, d)
  end

  #
  # Node Storage
  #   get stored Void* data
  #
  def data
    Lib.node_get_data(@raw_node)
  end

  #
  # Remove node from tree
  #
  def remove!
    Lib.node_remove(@raw_node)
  end

  #
  # Convert node to html string
  #   **deep** - option, means visit children nodes or not (by default true).
  #
  # Example:
  # ```
  # parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
  # node = parser.nodes(:div).first
  # node.to_html              # => `<div class="AAA" style="color:red">Haha <span>11</span></div>`
  # node.to_html(deep: false) # => `<div class="AAA" style="color:red">`
  # ```
  #
  def to_html(deep = true)
    str = Lib::MyhtmlStringRawT.new

    Lib.string_raw_clean_all(pointerof(str))

    res = if deep
            Lib.serialization(@raw_node, pointerof(str))
          else
            Lib.serialization_node(@raw_node, pointerof(str))
          end

    if res == Lib::MyStatus::MyCORE_STATUS_OK
      res = String.new(str.data, str.length)
      Lib.string_raw_destroy(pointerof(str), false)
      res
    else
      Lib.string_raw_destroy(pointerof(str), false)
      raise Error.new("Unknown problem with serialization: #{res}")
    end
  end

  #
  # Convert node to html to IO
  #   **deep** - option, means visit children nodes or not (by default true).
  #
  def to_html(io : IO, deep = true)
    iow = IOWrapper.new(io)

    if deep
      Lib.serialization_tree_callback(@raw_node, SERIALIZE_CALLBACK, iow.as(Void*))
    else
      Lib.serialization_node_callback(@raw_node, SERIALIZE_CALLBACK, iow.as(Void*))
    end
  end

  private class IOWrapper
    def initialize(@io : IO)
    end

    def write(b : Bytes)
      @io.write(b)
    end
  end

  SERIALIZE_CALLBACK = ->(text : UInt8*, length : LibC::SizeT, data : Void*) do
    data.as(IOWrapper).write(Bytes.new(text, length))
    Lib::MyStatus::MyCORE_STATUS_OK
  end

  #
  # Node Inner Text
  #   Joined text of children nodes
  #     **deep** - option, means visit children nodes or not (by default true).
  #     **join_with** - Char or String which inserted between text parts
  #
  # Example:
  # ```
  # parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
  # node = parser.nodes(:div).first
  # node.inner_text                 # => `Haha 11`
  # node.inner_text(deep: false)    # => `Haha `
  # node.inner_text(join_with: "/") # => `Haha /11`
  # ```

  def inner_text(join_with : String | Char | Nil = nil, deep = true)
    String.build { |io| inner_text(io, join_with: join_with, deep: deep) }
  end

  def inner_text(io : IO, join_with : String | Char | Nil = nil, deep = true)
    if (join_with == nil) || (join_with == "")
      each_inner_text(deep: deep) { |slice| io.write slice }
    else
      i = 0
      each_inner_text(deep: deep) do |slice|
        io << join_with if i != 0
        io.write Utils::Strip.strip_slice(slice)
        i += 1
      end
    end
  end

  protected def each_inner_text(deep = true)
    each_inner_text_for_scope(deep ? scope : children) { |slice| yield slice }
  end

  protected def each_inner_text_for_scope(scope)
    scope.nodes(Lib::MyhtmlTags::MyHTML_TAG__TEXT).each { |node| yield node.tag_text_slice }
  end

  #
  # Node Inspect
  #   puts node.inspect # => Myhtml::Node(tag_name: "div", attributes: {"class" => "aaa"})
  #
  def inspect(io : IO)
    io << "Myhtml::Node(tag_name: "
    Utils::Strip.string_slice_to_io_limited(tag_name_slice, io)

    if textable?
      io << ", tag_text: "
      Utils::Strip.string_slice_to_io_limited(tag_text_slice, io)
    else
      _attributes = @attributes

      if _attributes || any_attribute?
        io << ", attributes: {"
        c = 0
        if _attributes
          _attributes.each do |key, value|
            io << ", " unless c == 0
            Utils::Strip.string_slice_to_io_limited(key.to_slice, io)
            io << " => "
            Utils::Strip.string_slice_to_io_limited(value.to_slice, io)
            c += 1
          end
        else
          each_attribute do |key_slice, value_slice|
            io << ", " unless c == 0
            Utils::Strip.string_slice_to_io_limited(key_slice, io)
            io << " => "
            Utils::Strip.string_slice_to_io_limited(value_slice, io)
            c += 1
          end
        end
        io << '}'
      end
    end

    io << ')'
  end
end

require "./node/*"
