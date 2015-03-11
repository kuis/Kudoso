require 'socket'

begin
  loop do
    puts "Connecting"
    socket = TCPSocket.open('router.kudoso.com', 54283)
    puts "Connected"
    socket.puts("exit")
    socket.close
    puts "Close"
  
    sleep 60
  end
rescue => e
  puts "ERROR: #{e.inspect}"
end


`echo "kudoso down" | mail "ryanstout@gmail.com"`