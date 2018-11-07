require "./GoogleIsAnAPI/*"
require "myhtml"
require "http/client"
require "json"


# TODO: Write documentation for `GoogleIsAnAPI`
module GoogleIsAnAPI
  # TODO: Put your code here
  body = ""
  parsedData : JSON::Any

  client = HTTP::Client.new "www.google.com"
  response = client.get "/search?q=weather&oq=weather&aqs=chrome.0.69i59j69i65l2j0l3.2341j0j7&sourceid=chrome&ie=UTF-8"
  status = response.status_code

  if status >= 200 && status < 300
    body = response.body
    # puts body
    parsedData = decode(body)
  else
    error(status.to_s)
    parsedData = JSON::Any.new %({"failed" : "true"})
  end
  client.close
end

def decode(data : String) : JSON::Any
  htmlString = <<-PAGE
    #{data} 
  PAGE
  puts data
  puts "-------------------------------------------------------------"
  html = Myhtml::Parser.new(htmlString)
  puts html.css("div").map(&.attribute_by("id")).to_a

  # html.nodes(:div).each do |node|
  #   id = node.attribute_by("id")
  #   processNode(node)
  #   if first_link = node.scope.nodes(:a).first?
  #     href = first_link.attribute_by("href")
  #     link_text = first_link.inner_text

  #     puts "div with id #{id} have link [#{link_text}](#{href})"
  #   else
  #     puts "div with id #{id} have no links"
  #   end
  # end
  JSON::Any.new %({"failed" : "true"})
end

def processNode(id : String)
  if id == "wob_loc"

  end
end

def error(msg : String)
  # puts msg
end
