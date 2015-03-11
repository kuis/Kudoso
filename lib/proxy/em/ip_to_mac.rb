require_relative 'base_cache'
require_relative 'user_id_to_url_filter'

# Runs an arp scan to cache the ip -> [mac, name]
# where name is the computer name
class IpToMac < BaseCache
  def self.lookup_by_mac(mac)
    @mac_cache ||= {}
    return @mac_cache[mac]
  end

  # Get the routers mac address from ifconfig
  def self.get_router_mac_address
    results = `ifconfig`
    results.split(/\n/).each do |line|
      if line[0..3] == 'eth0'
        $router_mac_address = line.split(/ /).last
        puts "Set router mac address from ifconfig: #{$router_mac_address}"
        break
      end
    end
  end

  def self.update(start_timer=false, &block)
    @cache ||= {}
    @mac_cache ||= {}

    outstanding = 1 # start at 1 for the final finished

    # Capture outstanding in closure
    finished = Proc.new do
      outstanding -= 1

      if outstanding == 0
        UserIdToUrlFilter.update_ip_tables do
          # puts "Update IP tables"

          # We've loaded all ip and computer names, call if its not running
          block.call if block

          if start_timer
            # Only call if there's no id and no block
            EventMachine::Timer.new(15) do
              self.update(true)
            end
          end
        end
      end
    end

    # nmblookup -A ip_address
    # arp-scan --interface=eth1 --localnet
    EventMachine::system('ip neigh') do |results,status|
      devices = results.split("\n").map do |device|
        ip, _, device, _, mac, state = device.strip.split(/ /)

        [ip, device, mac, state]
      end

      # Get all other devices
      devices.each do |properties|
        # puts "PROPERTIES: #{properties}"
        ip, device, mac, state = properties
        next if mac == 'INCOMPLETE'

        # puts "Device: #{properties}"

        if device == 'eth0.1'
          # Skip router
          next
        end

        if state != 'REACHABLE'
          # Only use reachable states
          next
        end

        outstanding += 1
        EventMachine::system("sh -c \"nslookup #{ip} localhost 2> /dev/null\"") do |res,status2|
          name = nil
          name = res.split(/\n/).last if res
          name = name.split(/ /).last if name

          name ||= ip

          # puts name

          # Check to see if the device was there and the name has changed
          name_changed = (@cache[ip] && @cache[ip][1] != name)

          # Cache the ip -> mac
          @cache[ip] = [mac, name]
          @mac_cache[mac] = [ip, name]

          if name_changed
            MacToUserId.post_device(mac) {}
          end

          # Cache the mac -> user_id
          # puts "Do lookup on #{mac}"
          MacToUserId.lookup(mac) do
            # Done, mark finished
            finished.call
          end
        end
      end

      # One more finished, incase there were no devices?
      finished.call
    end
  end

end