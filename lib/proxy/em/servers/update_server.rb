# The app on all routers connects to this server, then sends a "join" message
# along with its mac address.  Other services can connect to this server and
# message the routers.  (This is similar to a chat room, where there is a
# room for each router)

require 'eventmachine'

$LOAD_PATH << File.expand_path('../lib', File.dirname(__FILE__))

require 'em-http-server'
require 'em-http-request'

STDOUT.sync = true

class UpdateServer < EventMachine::Connection
  def initialize
    @buffer = ''
    @@rooms ||= {}
    @@router_versions ||= {}
    # puts "Set start max version 0,1,6" unless defined? @@max_version
    # @@max_version ||= [0,1,6]

    # Timeout after 100 seconds (ping/pong happens every 30)
    self.comm_inactivity_timeout = 100.0
  end

  # def set_max_version(version)
  #   if version && version.strip != ''
  #     version = version.strip.split('.').map(&:to_i)
  #
  #     # Only update if we're at a newer version
  #     puts "Compare: #{@@max_version} <=> #{version} -- #{@@max_version <=> version}"
  #     if (@@max_version <=> version) == -1
  #       @@max_version = version
  #       puts "Set Max Version: #{version}"
  #     end
  #   end
  # end

  def receive_data(data)
    @buffer << data

    loop do
      if @buffer =~ /\n/
        break_index = @buffer.index(/\n/)
        if break_index
          line = @buffer[0...break_index]
          @buffer = @buffer[(break_index+1)..-1]

          process_command(line)
        end
      else
        break
      end
    end
  end

  def process_command(line)
    begin
      if line == 'exit'
        puts "Client Exit"
        close_connection
      else
        command, args = parse(line)

        if command == 'ping'
          # Return a pong for any pings
          send_data("pong\n")
        elsif command == 'join'
          router_mac_address, version = args.split('|')
          puts "VERSION: #{version}"

          # set_max_version(version)

          @@rooms ||= {}
          @@rooms[router_mac_address] ||= []
          @@rooms[router_mac_address] << self
          @@rooms[router_mac_address] = @@rooms[router_mac_address].uniq
          @room = router_mac_address

          @@router_versions[router_mac_address] = version

          # puts "Check version: #{version} <=> #{@@max_version}"
          # if @@max_version && (@@max_version <=> version.strip.split('.').map(&:to_i)) == 1
          #   puts "Upgrade router: #{router_mac_address}"
          #   # Auto update if needed
          #   message_user(router_mac_address, 'upgrade')
          # end
        elsif command == 'send'
          user, args = parse(args)

          message_user(user, args)
        else
          puts "UNRECOGNIZED COMMAND: #{command}"
        end
      end
    rescue => e
      puts "Error: #{e.inspect}\n#{e.backtrace}"
    end
  end

  def message_user(user, message)
    if @@rooms[user]
      @@rooms[user].each do |conn|
        conn.send_data(message.strip + "\n")
      end
    end
  end

  def parse(str)
    puts "Parsing string: #{str}"
    index = str.index('|')
    command = str[0...index]
    args = str[(index+1)..-1]

    return command, args
  end

  def unbind
    @@rooms.delete(@room) if @@rooms && @room
  end

end



class StatusServer < EventMachine::HttpServer::Server
  def process_http_request
    @owners ||= {}
    outstanding = 1

    if UpdateServer.class_variables.include?(:@@rooms)
      rooms = UpdateServer.class_variable_get('@@rooms')
      router_versions = UpdateServer.class_variable_get('@@router_versions')
      # max_version = UpdateServer.class_variable_get('@@max_version')
    else
      rooms = {}
      router_versions = {}
      # max_version = 0
    end


    finished = Proc.new do

      html = []
      html << "<h1>#{rooms.size} Routers Connected</h1>"

      html << '<table>'
      html << "<tr><td>Owner</td><td>Mac Address</td><td>Software Version</td></tr>"

      rooms.keys.each do |mac_address|
        html << "<tr><td>#{@owners[mac_address]}</td><td>#{mac_address}</td><td>#{router_versions[mac_address]}</td></tr>"
      end

      html << '</table>'

      response = EM::DelegatedHttpResponse.new(self)
      response.status = 200
      response.content_type 'text/html'
      response.content = html.join("\n")
      response.send_response
    end

    # Load all of the owners
    # rooms.keys.each do |mac_address|
    #   unless @owners[mac_address]
    #     outstanding += 1
    #     http = EventMachine::HttpRequest.new("http://www.kudoso.com/internal_apis/#{mac_address}").get
    #     http.errback do
    #       outstanding -= 1
    #       finished.call if outstanding == 0
    #     end
    #     http.callback do
    #       @owners[mac_address] = http.response
    #
    #       outstanding -= 1
    #       finished.call if outstanding == 0
    #     end
    #   end
    # end

    # Incase none ran
    outstanding -= 1
    finished.call if outstanding == 0
  rescue => e
    puts "Error: #{e.inspect} - #{e.backtrace}"
  end

  def finish

  end
end


EventMachine.run do
  puts "Starting Update Server"

  # Listen for cache clear requests
  EM.start_server '0.0.0.0', 54283, UpdateServer
  EM.start_server '0.0.0.0', 22848, StatusServer
end