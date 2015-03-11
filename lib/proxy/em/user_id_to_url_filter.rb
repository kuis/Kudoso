require 'json'
require_relative 'http_request'
require_relative 'base_cache'

class UserIdToUrlFilter < BaseCache
  def self.update(user_id, &block)
    @cache ||= {}
    @timers ||= {}


    if user_id == -1
      urls = ALWAYS_ALLOW_URLS
      cache_urls(user_id, urls)

      # A user id of -1 means the device isn't setup, redirect any url
      yield([@cache[user_id]])
      return
    elsif user_id.to_i == -2
      # A user id of -2 means the device has full bypass
      @cache[user_id] = '*'
      yield(@cache[user_id])
      return
    end

    HttpRequest.get("http://#{APP_DOMAIN}/users/#{user_id}/filters/current_filters.json") do |status, body|
      if status == 200
        if body.strip == '"*"'
          urls = '*'
        else
          begin
            data = JSON.parse(body)
          rescue JSON::ParserError => e
            puts "FAILED TO PARSE: #{body.inspect}"
            # raise
          end

          if @timers[user_id]
            # Clear any existing timers for this user
            @timers[user_id].cancel
          end

          clear_in = data['clear_in']
          urls = data['urls']

          urls += ALWAYS_ALLOW_URLS
          urls << APP_DOMAIN

          if clear_in
            # Create a clear timer
            @timers[user_id] = EventMachine::Timer.new(clear_in.to_i + 5) do
              @timers[user_id] = nil
              UserIdToUrlFilter.clear(user_id)
              IpToMac.update
            end
          end
        end

        cache_urls(user_id, urls)
      end

      yield(@urls) if block_given?
    end
  end

  def self.cache_urls(user_id, urls)
    if urls == '*'
      @cache[user_id] = '*'
    else
      cache = @cache[user_id] = {}

      # Also add in bypass on app domain
      urls = urls.uniq

      # Add the urls to the cache
      urls.each do |url|
        subdomain, domain, path = self.split_url(url)

        cache[domain] ||= {}
        cache[domain][subdomain] ||= []
        cache[domain][subdomain] << path
      end
    end
  end

  def self.bypass_ips
    @cache ||= {}
    @user_id_to_mac = Hash[MacToUserId.cache.to_a.map {|k| [k[1], k[0]] }]
    @mac_to_ip = Hash[IpToMac.cache.to_a.map {|k| [k[1][0], k[0]] }]

    # puts "user id to mac: #{@user_id_to_mac.inspect}"
    # puts "mac to ip: #{@mac_to_ip.inspect}"

    bypass_ips = []
    @cache.each_pair do |user_id,urls|
      if urls.is_a?(String) && urls == '*'
        mac = @user_id_to_mac[user_id]
        if mac
          ip = @mac_to_ip[mac]
          bypass_ips << ip if ip
        end
      end
    end

    return bypass_ips
  end


  # Takes a url and returns the subdomain, domain, and path
  def self.split_url(url)
    url = url.gsub(/^https?[:]\/\//, '')

    first_slash = url.index('/')
    full_domain = first_slash ? url[0...first_slash] : url
    path = first_slash ? url[first_slash..-1] : nil

    # puts "Full domain: #{full_domain.inspect}"
    domain = full_domain.match(/[^.]+[.][^.]+$/)
    if domain
      domain = domain[0]
    else
      domain = full_domain
    end

    subdomain_size = (full_domain.size - domain.size)
    if subdomain_size == 0
      subdomain = nil
    else
      subdomain = full_domain[0...(subdomain_size-1)]
    end

    # puts "#{subdomain} -- #{domain} -- #{path}"

    if subdomain == 'www'
      # www gets treated as a blank subdomain
      subdomain = nil
    end

    return subdomain, domain, path
  end

  def self.valid_url?(user_id, match_url, &block)
    subdomain, domain, path = self.split_url(match_url)

    self.lookup(user_id) do |urls|
      # puts "Compare: #{subdomain} -- #{domain} -- #{path} to #{urls.inspect}"
      # Handle the bipass route
      if urls.is_a?(String) && urls == '*'
        block.call(true)
      else
        # nil subdomain means match all, same with path
        if urls[domain] && (urls[domain][subdomain] || urls[domain][nil])
          if path
            matched = false
            match_paths = urls[domain][subdomain] || urls[domain][nil]
            match_paths.each do |match_path|
              if match_path == nil || path[/^#{match_path}/]
                # Matched
                # puts "matched: #{match_path} vs #{path}"
                block.call(true)
                matched = true
                break
              end
            end

            block.call(false) unless matched
          else
            block.call(true) # no path, just match
          end
        else
          # Didn't match domain and subdomain
          block.call(false)
        end
      end
    end
  end

  # Fetch the current prerouting NAT table and parse the results into an array
  def self.prerouting_data
    data = []
    i = 0
    EventMachine::system("iptables -L PREROUTING -t nat --line-numbers -n") do |results,status|
      results.split(/\n/).each do |line,status|
        i += 1
        next if i < 3
        line_number, target, protocol, options, source, destination, *args = line.split(/\s+/)

        data << [line_number, source, destination, args.join(' ')]
      end
      yield(data)
    end
  end

  def self.remove_unused(&block)
    commands = []
    self.prerouting_data do |data|
      current_bypassed_ips = data.select {|d| d[1] != '0.0.0.0/0' }.map {|d| d[1] }

      remove_bypass_for = current_bypassed_ips - bypass_ips

      remove_bypass_for.reverse.each do |remove_ip|
        line_number, _, _ = data.find {|d| d[1] == remove_ip }

        commands << "iptables -t nat -D PREROUTING #{line_number}" if line_number
      end

      run_commands(commands) do
        block.call
      end
    end
  end

  def self.run_after_update
    @run_after_update || []
  end

  # Write out the updated ip tables rules
  def self.update_ip_tables(&block)
    @run_after_update ||= []
    @run_after_update << (block || nil)

    if @run_after_update.size > 1
      # Already running
      return
    end

    # puts "--------- Start Update --------------"

    @running = true
    # iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8080
    # iptables -t nat -R PREROUTING #{https_line} -p tcp --dport 443 -j REDIRECT --to-port 8090
    # iptables -t nat -D PREROUTING #{line_number}

    # iptables -A OUTPUT -p tcp -s 192.168.0.194 --dport 80 -j ACCEPT
    # iptables -A OUTPUT -p tcp --dport 80 -j DROP

    # iptables -P INPUT --dport 80 -j DROP

    commands = []
    self.prerouting_data do |data|
      # puts "Prerouting Data: #{data.inspect}"
      http_line, *_ = data.find {|d| d[3] =~ /tcp dpt[:]80 redir ports 8081/ }
      https_line, *_ = data.find {|d| d[3] =~ /tcp dpt[:]443 redir ports 8080/ }

      # Add the main prerouting, unless its already been added
      commands << "iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8081" unless http_line
      commands << "iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8080" unless https_line

      # Figure out what ip's we need to add
      current_bypassed_ips = data.select {|d| d[1] != '0.0.0.0/0' }.map {|d| d[1] }
      bypass_ips = self.bypass_ips

      add_bypass_for = bypass_ips - current_bypassed_ips

      # Add those
      add_bypass_for.each do |bypass_ip|
        commands << "iptables -t nat -I PREROUTING 4 -p tcp -s #{bypass_ip} -j ACCEPT"
      end

      # Remove any ip's that we're not allowing bypass anymore
      commands << method(:remove_unused)

      run_commands(commands) do
        # puts "--------- Finished Update -------------"
        # After commands have run
        updates = @run_after_update.size
        @run_after_update.each do |block|
          block.call if block
        end
        @run_after_update = []

        if updates > 1
          # Run again, just to make sure everythings good
          self.update_ip_tables
        end

      end
    end
  end

  def self.run_commands(commands, &finished)
    command = commands.slice!(0)

    if command.is_a?(Proc) || command.is_a?(Method)
      command.call do
        run_commands(commands, &finished)
      end
    elsif command
      EventMachine::system(command) do |results|
        # next
        run_commands(commands, &finished)
      end
    else
      finished.call
    end
  end

end
