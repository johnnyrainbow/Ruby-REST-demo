require 'socket' # Provides TCPServer and TCPSocket classes
require 'cgi'

# Initialize a TCPServer object that will listen
# on localhost:2345 for incoming connections.

server = TCPServer.new('localhost', 2345)


# loop infinitely, processing one incoming
# connection at a time.
loop do

  # Wait until a client connects, then return a TCPSocket
  # that can be used in a similar fashion to other Ruby
  # I/O objects. (In fact, TCPSocket is a subclass of IO.)
  socket = server.accept

  # Read the first line of the request (the Request-Line)
  request = socket.gets

  # Log the request to the console for debugging
  STDERR.puts request


    admins = [['gabriel'], ['tom']] 

    arr = request.split(' ')
    p = CGI::parse(arr[1])
    input_val = p["/submit_name?name_field"]
   

    if(input_val == []) #no input val
      response = "<!DOCTYPE HTML>  <label>Enter your name</label><form action ='/submit_name' method = 'GET'><input name ='name_field'></form> "

    elsif(admins.include? input_val) #val is in admins arr
      puts "success, secret admin page"
      response = "<!DOCTYPE HTML><p>Hello %s </p> <a href = '/'><button type= 'button'>click here to go back</button></a>" % input_val

    else #input val exists but not one of admins
      response = "<!DOCTYPE HTML> <h3>You entered the name %s</h3> <label>Enter your name</label><form action ='/submit_name' method = 'GET'><input name ='name_field'></form> "% input_val

    end


  # We need to include the Content-Type and Content-Length headers
  # to let the client know the size and type of data
  # contained in the response. Note that HTTP is whitespace
  # sensitive, and expects each header line to end with CRLF (i.e. "\r\n")
  socket.print "HTTP/1.1 200 OK\r\n" +
               "Content-Type: text/html\r\n" +
               "Content-Length: #{response.bytesize}\r\n" +
               "Connection: close\r\n"

  # Print a blank line to separate the header from the response body,
  # as required by the protocol.
  socket.print "\r\n"

  # Print the actual response body, which is just "Hello World!\n"
  socket.print response

  # Close the socket, terminating the connection
  socket.close
end