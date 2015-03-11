require_relative 'http_request'
require_relative 'http_request2'
require_relative 'base_cache'
require_relative 'user_id_to_url_filter'
require_relative 'ip_to_mac'

class MacToUserId < BaseCache
  def self.update(mac, &block)
    @cache ||= {}

    url = "http://#{APP_DOMAIN}/devices/#{mac}.json?router_mac_address=#{$router_mac_address}"
    # puts "REGISTER DEVICE: " + url

    HttpRequest2.get(url) do |status, body|
      if status == 200
        # puts "DEVICE #{mac}: #{status.inspect} #{body.inspect}"
        body = body.strip if body

        if body == '' || body == '0'
          user_id = -1
        else
          user_id = body.to_i
        end
        @cache[mac] = user_id

        # Cache the url filters for user_id
        UserIdToUrlFilter.lookup(user_id, &block)
      elsif status == 404
        # puts "Device #{mac}: Not Found"
        # puts "POST? #{mac}"
        # puts "id for #{mac}: not found"
        # This means the device has never been seen, we should post the device
        # so that the "devices menu" can show it
        post_device(mac) do

          # Store that this device doesn't have a user_id assigned
          @cache[mac] = -1

          block.call if block
        end
      else
        puts "GOT ERROR from #{url}: #{status.inspect} -- #{body.inspect}"
        # TODO: Shouldn't get here
        block.call()
      end
    end
  end

  # When a new device is discovered, post the device to the server so the user
  # can select it from the devices list
  def self.post_device(mac)
    ip, name = IpToMac.lookup_by_mac(mac)

    # puts "Post Device: #{ip}, #{mac}, #{name}"
    # Post to server
    # POST plan/:plan_id/user_devices/create_or_update

    HttpRequest.post(
      "http://#{APP_DOMAIN}/devices",
      {ip: ip, router_mac_address: $router_mac_address, mac_address: mac, name: name}
    ) do |status, body|
      # puts "RESPONSE: #{status.inspect}"
      # puts body
      if status == 200
      end

      yield
    end
  end
end