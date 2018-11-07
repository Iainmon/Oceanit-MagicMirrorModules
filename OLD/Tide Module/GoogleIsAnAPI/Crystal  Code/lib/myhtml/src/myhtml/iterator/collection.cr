class Myhtml::Iterator::Collection
  include ::Iterator(Node)
  include Iterator::Filter

  @id : LibC::SizeT
  @parser : Parser
  @length : LibC::SizeT
  @list : Lib::MyhtmlTreeNodeT**
  @raw_collection : Lib::MyhtmlCollectionT*

  def initialize(@parser, @raw_collection)
    @id = LibC::SizeT.new(0)
    unless @raw_collection.null?
      @length = @raw_collection.value.length
      @list = @raw_collection.value.list
    else
      @length = LibC::SizeT.new(0)
      @list = Pointer(Lib::MyhtmlTreeNodeT*).new(0)
    end
    @finalized = false
  end

  def next
    if @id < @length
      node = @list[@id]
      @id += 1
      Node.new(@parser, node)
    else
      stop
    end
  end

  def size
    @length
  end

  def finalize
    free
  end

  def free
    unless @finalized
      @finalized = true
      Lib.collection_destroy(@raw_collection)
    end
  end

  def rewind
    @id = LibC::SizeT.new(0)
  end

  def inspect(io)
    io << "#<Myhtml::Iterator::Collection:0x"
    object_id.to_s(16, io)
    io << " elements: "
    @length.inspect(io)
    io << ", "
    io << "current: "
    @id.inspect(io)
    io << '>'
  end
end
