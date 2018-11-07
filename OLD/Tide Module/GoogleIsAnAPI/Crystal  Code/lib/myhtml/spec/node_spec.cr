require "./spec_helper"

describe Myhtml::Node do
  it "node from root" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div></body></html>")

    node = parser.root!.child!.next!.child!
    node.tag_name.should eq "div"
    node.attributes.should eq({"class" => "AAA", "style" => "color:red"})
    node.tag_id.should eq Myhtml::Lib::MyhtmlTags::MyHTML_TAG_DIV
    node.tag_sym.should eq :div
    node.child!.tag_text.should eq "Haha"
    node.attribute_by("class").should eq "AAA"
    node.attribute_by("class".to_slice).should eq "AAA".to_slice
    node.attribute_by("asfasdf").should eq nil
    node.attribute_by("asfasdf".to_slice).should eq nil
  end

  it "raise error when no node" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Hahasdfjasdfladshfasldkfhadsfkdashfaklsjdfhalsdfdsafsda</div></body></html>")
    node = parser.root!.child!.next!.child!.child!
    expect_raises(Myhtml::EmptyNodeError, /'child' called from Myhtml::Node/) { node.child! }
  end

  it "attributes" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div></body></html>")

    node = parser.root!.child!.next!.child!
    node.attributes.should eq({"class" => "AAA", "style" => "color:red"})
    node.attribute_by("class").should eq "AAA"
    node.attribute_by("class".to_slice).should eq "AAA".to_slice
  end

  it "add attribute" do
    parser = Myhtml::Parser.new("<html><body><div class=\"foo\">Haha</div></body></html>")

    node = parser.nodes(:div).first
    node.attribute_add("id", "bar")
    node.attributes.should eq({"class" => "foo", "id" => "bar"})
  end

  it "add attribute if attributes was cached" do
    parser = Myhtml::Parser.new("<html><body><div class=\"foo\">Haha</div></body></html>")

    node = parser.nodes(:div).first
    node.attributes.should eq({"class" => "foo"})
    node.attribute_add("id", "bar")
    node.attributes.should eq({"class" => "foo", "id" => "bar"})
  end

  it "remove attribute" do
    parser = Myhtml::Parser.new("<html><body><div class=\"foo\" id=\"bar\">Haha</div></body></html>")

    node = parser.nodes(:div).first
    node.attribute_remove("id")
    node.attributes.should eq({"class" => "foo"})

    node.attribute_remove("unkown")
    node.attributes.should eq({"class" => "foo"})
  end

  it "remove attribute if attributes was cached" do
    parser = Myhtml::Parser.new("<html><body><div class=\"foo\" id=\"bar\">Haha</div></body></html>")

    node = parser.nodes(:div).first
    node.attributes.should eq({"class" => "foo", "id" => "bar"})

    node.attribute_remove("id")
    node.attributes.should eq({"class" => "foo"})

    node.attribute_remove("unkown")
    node.attributes.should eq({"class" => "foo"})
  end

  it "ignore case attributes" do
    parser = Myhtml::Parser.new("<html><body><div Class=AAA STYLE='color:red'>Haha</div></body></html>")

    node = parser.root!.child!.next!.child!
    node.attributes.should eq({"class" => "AAA", "style" => "color:red"})
    node.attribute_by("class").should eq "AAA"
  end

  it "children" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.child!.next!
    node1, node2 = node.children.to_a
    node1.tag_name.should eq "div"
    node2.tag_name.should eq "span"
  end

  it "each_child" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.child!.next!
    nodes = [] of Myhtml::Node
    node.children.each { |ch| nodes << ch }
    node1, node2 = nodes
    node1.tag_name.should eq "div"
    node2.tag_name.should eq "span"
  end

  it "each_child iterator" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.child!.next!
    node1, node2 = node.children.to_a
    node1.tag_name.should eq "div"
    node2.tag_name.should eq "span"
  end

  it "parents" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.right_iterator.to_a.last
    parents = node.parents.to_a
    parents.size.should eq 2
    node1, node2 = parents
    node1.tag_name.should eq "body"
    node2.tag_name.should eq "html"
  end

  it "each_parent" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.right_iterator.to_a.last
    parents = [] of Myhtml::Node
    node.parents.each { |ch| parents << ch }
    parents.size.should eq 2
    node1, node2 = parents
    node1.tag_name.should eq "body"
    node2.tag_name.should eq "html"
  end

  it "each_parent iterator" do
    parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha</div><span></span></body></html>")

    node = parser.root!.right_iterator.to_a.last
    parents = node.parents.to_a
    parents.size.should eq 2
    node1, node2 = parents
    node1.tag_name.should eq "body"
    node2.tag_name.should eq "html"
  end

  it "visible?" do
    parser = Myhtml::Parser.new("<body><style>bla</style></body>")
    node = parser.root!.right_iterator.to_a[-2]
    node.tag_name.should eq "style"
    node.visible?.should eq false

    parser = Myhtml::Parser.new("<body><div>bla</div></body>")
    node = parser.root!.right_iterator.to_a[-2]
    node.tag_name.should eq "div"
    node.visible?.should eq true
  end

  it "object?" do
    parser = Myhtml::Parser.new("<body><object>bla</object></body>")
    node = parser.root!.right_iterator.to_a[-2]
    node.tag_name.should eq "object"
    node.object?.should eq true
    node.child!.object?.should eq false
  end

  it "is_tag_div?" do
    parser = Myhtml::Parser.new("<div>1</div>")
    noindex = parser.root!.right_iterator.to_a[-2]
    noindex.tag_name.should eq "div"
    noindex.is_tag_div?.should eq true
    noindex.child!.is_tag_div?.should eq false
  end

  it "is_tag_noindex?" do
    parser = Myhtml::Parser.new("<noindex>1</noindex>")
    noindex = parser.root!.right_iterator.to_a[-2]
    noindex.tag_name.should eq "noindex"
    noindex.is_tag_noindex?.should eq true
    noindex.child!.is_tag_noindex?.should eq false

    parser = Myhtml::Parser.new("<NOINDEX>1</NOINDEX>")
    noindex = parser.root!.right_iterator.to_a[-2]
    noindex.tag_name.should eq "noindex"
    noindex.is_tag_noindex?.should eq true
    noindex.child!.is_tag_noindex?.should eq false
  end

  it "remove!" do
    html_string = "<html><body><div id='first'>Haha</div><div id='second'>Hehe</div><div id='third'>Hoho</div></body></html>"
    id_array = %w(first second third)
    (0..2).each do |i|
      parser = Myhtml::Parser.new html_string
      parser.root!.child!.next!.children.to_a.at(i).remove!
      parser.root!.child!.next!.children.to_a.map(&.attribute_by("id")).should(
        eq id_array.dup.tap(&.delete_at(i))
      )
    end
  end

  it "get set data" do
    parser = Myhtml::Parser.new("<body><object>bla</object></body>")
    node = parser.body!

    str = "bla"

    node.data = str.as(Void*)

    body2 = parser.root!.child!.next!
    body2.data.as(String).should eq str

    parser.root!.data.null?.should eq true
  end

  context "to_html" do
    it "deep" do
      parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
      node = parser.nodes(:div).first
      node.to_html.should eq %Q[<div class="AAA" style="color:red">Haha <span>11</span></div>]
    end

    it "flat" do
      parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
      node = parser.nodes(:div).first
      node.to_html(deep: false).should eq %Q[<div class="AAA" style="color:red">]
    end

    it "deep io" do
      parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
      node = parser.nodes(:div).first
      io = IO::Memory.new
      node.to_html(io)
      io.rewind
      io.gets_to_end.should eq %Q[<div class="AAA" style="color:red">Haha <span>11</span></div>]
    end

    it "flat io" do
      parser = Myhtml::Parser.new("<html><body><div class=AAA style='color:red'>Haha <span>11</span></div></body></html>")
      node = parser.nodes(:div).first
      io = IO::Memory.new
      node.to_html(io, deep: false)

      io.rewind
      io.gets_to_end.should eq %Q[<div class="AAA" style="color:red">]
    end
  end

  context "inner_text" do
    it do
      parser = Myhtml::Parser.new("<html><body>1<div class=AAA style='color:red'>Haha<span>11</span>bla</div> 2 </body></html>")
      parser.body!.inner_text(join_with: ' ').should eq "1 Haha 11 bla 2"
      parser.body!.inner_text(join_with: ' ', deep: false).should eq "1 2"
    end

    it do
      parser = Myhtml::Parser.new("<html><div>bla<b>11</b>12</div></html>")
      parser.nodes(:div).first.inner_text(join_with: ' ').should eq "bla 11 12"
    end

    it do
      parser = Myhtml::Parser.new("<html><div>bla<b>11</b>12</div></html>")
      parser.nodes(:div).first.inner_text(join_with: '-').should eq "bla-11-12"
    end

    it do
      parser = Myhtml::Parser.new("<html><div>bla<b>11</b>12</div></html>")
      parser.nodes(:div).first.inner_text(join_with: "").should eq "bla1112"
    end

    it do
      parser = Myhtml::Parser.new("<html><div>bla<b>11</b>12</div></html>")
      parser.nodes(:div).first.inner_text(join_with: "==").should eq "bla==11==12"
    end

    it do
      parser = Myhtml::Parser.new("<html><div><b>11</b> </div></html>")
      parser.nodes(:div).first.inner_text(join_with: ' ').should eq "11 "
    end

    it do
      parser = Myhtml::Parser.new("<html><body>1<div class=AAA style='color:red'>Haha<span>11</span>bla</div> 2 </body></html>")
      parser.body!.inner_text(join_with: nil).should eq "1Haha11bla 2 "
      parser.body!.inner_text(join_with: nil, deep: false).should eq "1 2 "
    end

    it do
      parser = Myhtml::Parser.new("<html><body>1<div class=AAA style='color:red'>Haha<span>11</span>bla</div> 2 </body></html>")
      parser.nodes(:div).first.inner_text.should eq "Haha11bla"
      parser.nodes(:div).first.inner_text(deep: false).should eq "Hahabla"
    end

    it do
      parser = Myhtml::Parser.new("<html><body>1<div class=AAA style='color:red'>Haha<span>11</span>bla</div> 2 </body></html>")
      parser.nodes(:span).first.inner_text.should eq "11"
      parser.nodes(:span).first.inner_text(deep: false).should eq "11"
    end
  end

  context "inspect" do
    context "work" do
      parser = Myhtml::Parser.new(%Q[<html><body><div class=AAA style='color:red'>Haha <span>11<a href="#" class="AAA">jopa</a></span></div>
        <div>#{"bla" * 30}</div></body></html>])

      it do
        node = parser.nodes(:div).first
        node.inspect.should eq "Myhtml::Node(tag_name: \"div\", attributes: {\"class\" => \"AAA\", \"style\" => \"color:red\"})"
      end

      it do
        node = parser.nodes(:div).first
        node.attributes
        node.inspect.should eq "Myhtml::Node(tag_name: \"div\", attributes: {\"class\" => \"AAA\", \"style\" => \"color:red\"})"
      end

      it do
        node = parser.nodes(:div).first
        node.child!.inspect.should eq "Myhtml::Node(tag_name: \"-text\", tag_text: \"Haha \")"
      end

      it do
        node = parser.nodes(:span).first
        node.inspect.should eq "Myhtml::Node(tag_name: \"span\")"
      end

      it do
        node = parser.nodes(:div).to_a[1]
        node.child!.inspect.should eq "Myhtml::Node(tag_name: \"-text\", tag_text: \"blablablablablablablablablabla...\")"
      end
    end
  end
end
