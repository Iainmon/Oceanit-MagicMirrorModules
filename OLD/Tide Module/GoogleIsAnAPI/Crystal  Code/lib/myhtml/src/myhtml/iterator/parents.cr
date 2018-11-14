struct Myhtml::Iterator::Parents
  include ::Iterator(Node)
  include Iterator::Filter

  @start_node : Node
  @current_node : Node? = nil

  def initialize(@start_node)
    rewind
  end

  def next
    @current_node = @current_node.not_nil!.parent
    if (cn = @current_node) && (cn.tag_id != Lib::MyhtmlTags::MyHTML_TAG__UNDEF)
      cn
    else
      stop
    end
  end

  def rewind
    @current_node = @start_node
  end
end
