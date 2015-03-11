require 'uri'

class HttpRequest2 < EventMachine::Connection
  def self.get(url, &block)
    # puts "Get2: #{url}"
    uri = URI.parse(url)
    EventMachine.connect(uri.host, uri.port, self, uri, block)
  end

  def initialize(uri, block)
    super()
    @uri = uri
    @block = block
    @buffer = ''
  end

  def post_init
    # puts "Connect to #{@uri.host}, #{@uri.port} - #{@uri.path}"
    # Make request
    path_and_query = @uri.path
    path_and_query += '?' + @uri.query if @uri.query && @uri.query != ''

    send_data("GET #{path_and_query} HTTP/1.0\r\nHost: #{@uri.host}\r\n\r\n")
  end

  def receive_data(data)
    @buffer << data

    if @buffer =~ /\r\n\r\n/
      headers, body = @buffer.split(/\r\n\r\n/)

      lines = headers.split(/\r\n/)
      _, status, _ = lines[0].split(/ /)
      status = status.to_i

      # puts "Status: #{status}, Body: #{body.inspect}"
      if status != 200
        body = ''
      end

      # Done
      @block.call(status.to_i, body)

      close_connection
    end
  end
end