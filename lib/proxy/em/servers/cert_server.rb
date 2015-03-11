# Cert server runs in production and does the generation of all of the
# MITM ssl certificates.  It uses a basic line protocol.

require 'rubygems'
require 'gserver'
require File.dirname(__FILE__) + '/../certificate'

class CertServer < GServer
  def initialize
    super(2000, nil, 10)
  end

  def serve(client)
    hostname = client.gets.strip
    puts "Load: #{hostname}"

    begin
      key, pem = Certificate.generate(hostname)

      client.puts(File.read(key))
      client.puts("\r\n")

      client.puts(File.read(pem))
      client.puts("\r\n")
    rescue => e
      # failed
      client.puts("---\r\n---\r\n")
    end

  rescue Exception => e
    puts e.inspect
    puts e.backtrace
  end
end


puts "Starting Cert Server"
server = CertServer.new
server.audit = true
server.start
server.join
puts "Started?"