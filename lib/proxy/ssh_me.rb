#!/usr/bin/env ruby -w

# ./ssh_me.rb MacAddress LocalPublicIp

require 'socket'


def send_to_router(command)
  connection = TCPSocket.new('router.kudoso.com', 54283)
  connection.puts("send|#{ARGV[0]}|upgrade_command:#{command}\n")
  connection.close
end

puts "Telling #{ARGV[0]} to connect to router.kudoso.com"

Thread.new do
  # Connect device to router.kudoso.com
  code = <<-END
  require 'pty'
  require 'expect'
  PTY.spawn("ssh updjwic9@router.kudoso.com -R 2222:localhost:22") do |reader, writer, pid|
    res = reader.expect(/Do you want to continue connecting/, 2)
    if res && res.first.match("Do you")
      puts "yes to connect"
      writer.puts(["y", 10.chr].join(""))
    end
    reader.expect(/updjwic9@router.kudoso.com/)
    puts "password"
    writer.puts("39vsfi29sijfgjsl")
    reader.expect(/notgoingtosee/)
  end
  END

  command = "ruby -e #{code.split(/\n/).join(' ; ').inspect}"

  send_to_router(command)
end

sleep 5

puts "Run this:\nssh root@localhost -p 2222"

require 'pty'
require 'expect'
PTY.spawn("ssh root@router.kudoso.com -L 2222:localhost:2222") do |reader, writer, pid|
  puts "Press enter to close"
  $stdin.gets


  # Close connection on router
  send_to_router('killlast')

  writer.puts("exit")

end
