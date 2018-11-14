module Myhtml::Utils::HtmlEntities
  # !this object never freed!
  HTML_ENTITIES_NODE = Myhtml::Parser.new("1", tree_options: Myhtml::Lib::MyhtmlTreeParseFlags::MyHTML_TREE_PARSE_FLAGS_WITHOUT_DOCTYPE_IN_TREE).body!.child!

  def self.decode(str : String)
    HTML_ENTITIES_NODE.tag_text_set(str, Lib::MyEncodingList::MyENCODING_DEFAULT)
    HTML_ENTITIES_NODE.tag_text
  end
end
