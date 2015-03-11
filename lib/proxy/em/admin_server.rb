# The admin server is for the router admin when the router is not connected
# to the internet.  It displays a javascript admin that can run commands
# on the router to set things.

require 'eventmachine'
require 'em-http-server'

class AdminServer < EventMachine::HttpServer::Server
  def process_http_request
    path = @http_request_uri

    response = EM::DelegatedHttpResponse.new(self)

    if path == '/command'
      run_command(@http_query_string, response)
      return
    elsif path == '/ping'
      ping(response)
    end


    if path[-1..-1] == '/'
      path += 'index.html'
    end

    full_path = File.expand_path("public#{path}", File.dirname(__FILE__))
    response.content_type(mime_type(full_path))

    if File.exists?(full_path)
      puts "Found: #{full_path}"
      response.status = 200
      response.content = File.read(full_path)
      response.send_response
    else
      puts "Not Found: #{full_path}"
      response.status = 404
      response.content = 'Not Found'
      response.send_response
    end

  end

  # Return an empty string for ping
  def ping
    response.status = 200
    response.content = ''
    response.send_response
  end

  def run_command(query_string, response)
    # puts "Run Command: #{query_string}"
    parts = query_string.split('&')

    parts.map! {|p| equals_pos = p.index('=') ; [p[0...equals_pos], url_unescape(p[(equals_pos+1)..-1])]}

    params = Hash[*parts.flatten]

    command = params['c'].strip

    puts "Run Command: #{command}"

    result = `#{command}`.strip

    response.content = result
    response.content_type('text/html')
    response.status = 200
    response.send_response
  rescue => e
    response.content = '!!error'
    response.content_type('text/html')
    response.status = 200
    response.send_response
    puts "Error: #{e.inspect} - #{e.backtrace}"
  end


  def url_unescape(string)
    string.tr('+', ' ').gsub(/((?:%[0-9a-fA-F]{2})+)/n) do
      [$1.delete('%')].pack('H*')
    end
  end

  def mime_type(path)
    @mime_types ||= read_mime_types
    extension = path[/[^.]$/]

    return @mime_types[extension] || 'text/html'
  end

  def read_mime_types
    types = {}
    File.read(File.expand_path("data/mime_types", File.dirname(__FILE__))).split(/\n/).each do |line|
      content_type, ext = line.split(/\s+/)

      types[ext] = content_type
    end

    return types
  end

  def self.start
    puts "Start Admin Server"
    # Try to bind
    begin
      EM::start_server("192.168.98.1", 10000, self)
    rescue => e
      puts "UNABLE TO CONNECT ADMIN SERVER: #{e.inspect}\n\n#{e.backtrace}"
    end
  end
end