require 'socket'

class CertificateClient
  def self.lookup(hostname, &block)
    # puts "Lookup #{hostname}"
    begin
      socket = TCPSocket.new(ROUTER_SERVER_DOMAIN, 2000)

      socket.puts("#{hostname}\n")

      buffer = ''
      loop do
        buffer << socket.read

        if buffer.split(/\r\n/).size == 2
          break
        end
      end

      socket.close
    rescue Errno::ECONNREFUSED => e
      puts "CONNECTION FAILED -- BLANK KEYS"
      # Couldn't connect, return blank for both
      block.call("", "")
    end

    # puts "Looked up: #{hostname}"
    key, pem = buffer.split(/\r\n/)

    key.strip!
    pem.strip!

    # puts "Key: #{key.size}, Pem: #{pem.size}"

    block.call(key, pem)
  end
end