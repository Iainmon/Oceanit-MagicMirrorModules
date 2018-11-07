class Myhtml::Parser
  # :nodoc:
  getter encoding : Lib::MyEncodingList

  #
  # Parse html from string
  # example: myhtml = Myhtml::Parser.new("<html>...</html>", encoding: Myhtml::Lib::MyEncodingList::MyENCODING_WINDOWS_1251)
  #
  # Options:
  #   **encoding** - set encoding of html (see list of encodings in Myhtml::Lib::MyEncodingList), by default it parsed as UTF-8
  #   **detect_encoding_from_meta** - try to find encoding from meta tag in the html (<meta charset=...>)
  #   **detect_encoding** - detect encoding by slow trigrams algorithm
  #   **tree_options** - additional myhtml options for parsing (see Myhtml::Lib::MyhtmlTreeParseFlags)
  #

  def self.new(page : String,
               encoding : Lib::MyEncodingList? = nil,
               detect_encoding_from_meta : Bool = false,
               detect_encoding : Bool = false,
               tree_options : Lib::MyhtmlTreeParseFlags? = nil)
    self.new(tree_options: tree_options,
      encoding: encoding,
      detect_encoding_from_meta: detect_encoding_from_meta,
      detect_encoding: detect_encoding).parse(page)
  end

  #
  # Parse html from IO
  # example: myhtml = Myhtml::Parser.new(io, encoding: Myhtml::Lib::MyEncodingList::MyENCODING_WINDOWS_1251)
  #
  # Options:
  #   **encoding** - set encoding of html (see list of encodings in Myhtml::Lib::MyEncodingList), by default it parsed as UTF-8
  #   **tree_options** - additional myhtml options for parsing (see Myhtml::Lib::MyhtmlTreeParseFlags)
  #

  def self.new(io : IO,
               tree_options : Lib::MyhtmlTreeParseFlags? = nil,
               encoding : Lib::MyEncodingList? = nil)
    self.new(tree_options: tree_options, encoding: encoding).parse_stream(io)
  end

  #
  # Root nodes for parsed tree
  #   **myhtml.body!** - body node
  #   **myhtml.head!** - head node
  #   **myhtml.root!** - html node
  #   **myhtml.document!** - document node
  #
  {% for name in %w(head body html root) %}
    def {{ name.id }}
      Node.from_raw(self, Lib.tree_get_node_{{(name == "root" ? "html" : name).id}}(@raw_tree))
    end

    def {{ name.id }}!
      if val = {{ name.id }}
        val
      else
        raise EmptyNodeError.new("expected `{{name.id}}` to present on myhtml tree")
      end
    end
  {% end %}

  def document!
    if node = Node.from_raw(self, Lib.tree_get_document(@raw_tree))
      node
    else
      raise EmptyNodeError.new("expected document to present on myhtml tree")
    end
  end

  #
  # Top level node filter (select all nodes in tree with tag_id)
  #   returns Myhtml::Iterator::Collection
  #   equal with myhtml.root!.scope.nodes(...)
  #
  #   myhtml.nodes(Myhtml::Lib::MyhtmlTags::MyHTML_TAG_DIV).each { |node| ... }
  #
  def nodes(tag_id : Myhtml::Lib::MyhtmlTags)
    Iterator::Collection.new(self, Lib.get_nodes_by_tag_id(@raw_tree, nil, tag_id, out status))
  end

  #
  # Top level node filter (select all nodes in tree with tag_sym)
  #   returns Myhtml::Iterator::Collection
  #   equal with myhtml.root!.scope.nodes(...)
  #
  #   myhtml.nodes(:div).each { |node| ... }
  #
  def nodes(tag_sym : Symbol)
    nodes(Utils::TagConverter.sym_to_id(tag_sym))
  end

  #
  # Top level node filter (select all nodes in tree with tag_sym)
  #   returns Myhtml::Iterator::Collection
  #   equal with myhtml.root!.scope.nodes(...)
  #
  #   myhtml.nodes("div").each { |node| ... }
  #
  def nodes(tag_str : String)
    nodes(Utils::TagConverter.string_to_id(tag_str))
  end

  #
  # Css selectors, see Node#css
  #
  delegate :css, to: root!

  #
  # Convert html tree to html string
  #
  delegate :to_html, to: document!

  #
  # Initialize
  #
  protected def initialize(tree_options : Lib::MyhtmlTreeParseFlags? = nil,
                           encoding : Lib::MyEncodingList? = nil,
                           @detect_encoding_from_meta : Bool = false,
                           @detect_encoding : Bool = false)
    options = Lib::MyhtmlOptions::MyHTML_OPTIONS_PARSE_MODE_SINGLE
    threads_count = 1
    queue_size = 0
    @encoding = encoding || Lib::MyEncodingList::MyENCODING_DEFAULT

    @raw_myhtml = Lib.create
    res = Lib.init(@raw_myhtml, options, threads_count, queue_size)
    if res != Lib::MyStatus::MyCORE_STATUS_OK
      raise Error.new("init error #{res}")
    end

    @raw_tree = Lib.tree_create
    res = Lib.tree_init(@raw_tree, @raw_myhtml)

    if res != Lib::MyStatus::MyCORE_STATUS_OK
      Lib.destroy(@raw_myhtml)
      raise Error.new("tree_init error #{res}")
    end

    Lib.tree_parse_flags_set(@raw_tree, tree_options) if tree_options
    @finalized = false
  end

  # Dangerous, manually free object (free also safely called from GC finalize)
  def free
    unless @finalized
      @finalized = true
      Lib.tree_destroy(@raw_tree)
      Lib.destroy(@raw_myhtml)
    end
  end

  def finalize
    free
  end

  protected def parse(string)
    pointer = string.to_unsafe
    bytesize = string.bytesize

    if Lib.encoding_detect_and_cut_bom(pointer, bytesize, out encoding2, out pointer2, out bytesize2)
      pointer = pointer2
      bytesize = bytesize2
      @encoding = encoding2
    else
      detected = false

      if @detect_encoding_from_meta
        if enc = Utils::DetectEncoding.from_meta?(pointer, bytesize)
          detected = true
          @encoding = enc
        end
      end

      if @detect_encoding && !detected
        if enc = Utils::DetectEncoding.detect?(pointer, bytesize)
          @encoding = enc
        end
      end
    end

    res = Lib.parse(@raw_tree, @encoding, pointer, bytesize)
    if res != Lib::MyStatus::MyCORE_STATUS_OK
      free
      raise Error.new("parse error #{res}")
    end

    self
  end

  BUFFER_SIZE = 8192

  protected def parse_stream(io : IO)
    buffers = Array(Bytes).new
    Lib.encoding_set(@raw_tree, @encoding)

    loop do
      buffer = Bytes.new(BUFFER_SIZE)
      read_size = io.read(buffer)
      break if read_size == 0

      buffers << buffer
      res = Lib.parse_chunk(@raw_tree, buffer.to_unsafe, read_size)
      if res != Lib::MyStatus::MyCORE_STATUS_OK
        free
        raise Error.new("parse_chunk error #{res}")
      end
    end

    res = Lib.parse_chunk_end(@raw_tree)
    if res != Lib::MyStatus::MyCORE_STATUS_OK
      free
      raise Error.new("parse_chunk_end error #{res}")
    end

    self
  end
end
