# Example: print all html tree

require "../src/myhtml"

def walk(node, level = 0)
  puts "#{" " * level * 2}#{node.inspect}"
  node.children.each { |child| walk(child, level + 1) }
end

str = if filename = ARGV[0]?
        File.read(filename, "UTF-8", invalid: :skip)
      else
        "<html><Div><span class='test'>HTML</span></div></html>"
      end

parser = Myhtml::Parser.new(str, tree_options: Myhtml::Lib::MyhtmlTreeParseFlags::MyHTML_TREE_PARSE_FLAGS_SKIP_WHITESPACE_TOKEN)
walk(parser.root!)

# Output:
# Myhtml::Node(tag_name: "html")
#   Myhtml::Node(tag_name: "head")
#   Myhtml::Node(tag_name: "body")
#     Myhtml::Node(tag_name: "div")
#       Myhtml::Node(tag_name: "span", attributes: {"class" => "test"})
#         Myhtml::Node(tag_name: "-text", tag_text: "HTML")
