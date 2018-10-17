require "http/client"
require "xml"
require "json"

body = ""
parsedData : JSON::Any

client = HTTP::Client.new "www.google.com"
response = client.get "/search?q=weather"
status = response.status_code

if status >= 200 && status < 300
  body = response.body
  # body = body[15..-1]
  puts body
  parsedData = decode(body)
else
  error(status.to_s)
  parsedData = JSON::Any.new %({"failed" : "true"})
end
client.close

def decode(data : String) : JSON::Any
  firstBody = data.rindex("<body class")
  secondBody = data.rindex("</body>")
  # data[14448..46039] #works
  if (firstBody == nil || secondBody == nil)
    return JSON::Any.new %({"failed" : "true"})
  end
  data[firstBody.to_i32..secondBody.to_i32]
  

  #     node = XML.parse_html(data)
  # # 		node = node.to_s.split "#"
  # # nodes = [""]
  # # 		node.each do |oneNode|
  # #   oneNode.split "<style>"
  # #   oneNode.split "</style>"
  # # 		end
  # 		puts node

end

def error(msg : String)
  # puts msg
end
