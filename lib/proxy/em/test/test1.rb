require 'socket'
require 'socket'
require 'openssl'
require 'uri'

#For some reason, ruby doesn't define this constant
if not Socket.const_defined? 'SO_ORIGINAL_DST'
  Socket.const_set 'SO_ORIGINAL_DST', 80
end


server = TCPServer.new 2000

loop do
  client = server.accept
  # Thread.new(client) do |client|
    dummy, port, host = client.getsockopt(Socket::SOL_IP, Socket::SO_ORIGINAL_DST).unpack("nnN")
    puts "#{host}, #{post}"
  # end

  client.close
end