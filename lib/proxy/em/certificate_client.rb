# We're not able to push this back to the reactor in the current EM

class CertificateClient < EventMachine::Connection
  def initialize(hostname, &block)
    @hostname = hostname
    puts "HOST: #{@hostname}"
    @block = block
    @buffer = ''
  end

  def connection_completed
    puts "Send Hostname: #{@hostname}"
    send_data("#{@hostname}\n")
  end

  def receive_data(data)
    puts "Receive: #{data}"
    @buffer << data
  end

  def unbind
    puts "UNBIND: #{@buffer}"
    key, pem = @buffer.split(/\r\n/)
    puts key
    puts '----------'
    puts pem

    @block.call(key, pem)
  end

  def self.lookup(hostname, &block)
    EventMachine::connect('localhost', 2000, self, hostname, &block)
  end
end