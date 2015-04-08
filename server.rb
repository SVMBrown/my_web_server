require 'socket'                                    # Require socket from Ruby Standard Library (stdlib)

host = 'localhost'
port = 2000

server = TCPServer.open(host, port)                 # Socket to listen to defined host and port
puts "Server started on #{host}:#{port} ..."        # Output to stdout that server started

loop do                                             # Server runs forever
  client = server.accept                            # Wait for a client to connect. Accept returns a TCPSocket

  lines = []
  while (line = client.gets) && !line.empty?  # Read the request and collect it until it's empty
    lines << line
  end
  puts lines                                        # Output the full request to stdout
  #filename = "index.html"
  header_array = []
  filename = lines[0].gsub(/GET \//, '').gsub(/\ HTTP.*/, '')
  if File.exists?(filename)
    response_body = File.read(filename)
    header_array << "HTTP/1.1 200 OK"
    header_array << "Content-Type: text/html"
  else
    response_body = "File not found\n"
    header_array << "HTTP/1.1 404 Not Found"
    header_array << "text/plain"
  end
  header_array << "Content-Length: #{response_body.length}"
  header_array << "Connection: close"
  header = header_array.join("\r\n")
  response_array = []
  response_array << header
  response_array << response_body
  response = response_array.join("\r\n\r\n")
  client.puts(response)                       # Output the current time to the client
  client.close                                      # Disconnect from the client
end
