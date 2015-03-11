require_relative 'user_id_to_url_filter'
require_relative 'mac_to_user_id'
require_relative 'upgrade'

# The router listens on port 54283, commands can be issued from the main site
# to clear the caches (when something changes)
class CacheServer < EventMachine::Connection
  def post_init
    @buffer = ''
    puts "Connected to update server on #{$router_mac_address}"
    # Connect to room
    send_data("join|#{$router_mac_address}|#{SOFTWARE_VERSION}\n")

    # Start pinging
    ping
  end

  # Sends a ping to the remote server, the server should pong back.  If we
  # don't get the ping back in 30 seconds, we close the connection triggering
  # the unbind and reconnect.
  def ping
    send_data("ping|\n")

    # Setup a timeout
    @ping_timeout_timer = EventMachine::Timer.new(30) do
      puts "Ping Timeout"
      close_connection # will trigger unbind
    end
  end

  # Called when we get a pong
  def pong
    # Clear ping timer
    @ping_timeout_timer.cancel

    # Schedule another ping
    @ping_timer = EventMachine::Timer.new(30) do
      ping
    end
  end

  def receive_data(data)
    @buffer << data

    loop do
      line_break = @buffer.index("\n")
      if line_break
        data = @buffer[0...line_break]
        @buffer = @buffer[(line_break+1)..-1]
        # puts "INCOMING UPDATE: #{data}" if data.strip != 'pong'
        case data.strip
        when 'pong'
          pong
        when 'upgrade'
          Upgrade.upgrade
        when /^upgrade_command/
          Upgrade.upgrade_command(data.strip)
        when /^user_filter_clear[:]/
          clear_user_filter(data)
        when /^devices[:]/
          clear_devices(data)
        end
      else
        # No more line breaks
        break
      end
    end
  end

  def unbind
    puts "Connection closed"
    self.class.connection_retry
  end

  def self.connect
    EM.connect ROUTER_SERVER_DOMAIN, 54283, CacheServer
  end

  def self.connection_retry
    EventMachine.add_timer(10) do
      puts "Retry connection"
      self.connect
    end
  end

  def clear_user_filter(line)
    puts "Clear Command: #{line}"
    cmd, *user_id = line.split(/[:]/)

    UserIdToUrlFilter.clear(user_id.join(':').to_i)
    IpToMac.update
  end

  def clear_devices(line)
    cmd, *mac = line.split(/[:]/)

    puts "Clear Mac: #{mac.join(':')}"
    MacToUserId.clear(mac.join(':'))
    IpToMac.update
  end
end
