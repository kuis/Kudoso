#!/usr/bin/ruby

# iptables -t nat -A PREROUTING -p tcp --dport 443 -j REDIRECT --to-port 8080
# iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-port 8081

# Get the hostnames
# arp -a
# Get the ip/mac/name
# sudo arp-scan --interface=eth1 --localnet



# https://github.com/alloy/ssalleyware/blob/master/lib/ssalleyware.rb

# require 'rubygems'
# require 'eventmachine'
# begin
#   # require 'em/pure_ruby'
#   # require '/usr/lib/ruby/site_ruby/1.9/mips-linux/rubyeventmachine.so'
# rescue LoadError => e
#   require 'eventmachine'
# end

# Need to add this to the path for eventmachine
if File.exists?('/usr/lib/ruby/site_ruby/1.9/mips-linux/')
  $LOAD_PATH << '/usr/lib/ruby/site_ruby/1.9/mips-linux/'
end

puts "ADD: #{File.expand_path('lib', File.dirname(__FILE__))}"
$LOAD_PATH << File.expand_path('lib', File.dirname(__FILE__))


require 'eventmachine'
require_relative 'certificate_client2'
# require_relative 'certificate_client_local'
require_relative 'ip_to_mac'
require_relative 'mac_to_user_id'
require_relative 'user_id_to_url_filter'
require_relative 'cache_server'
require_relative 'admin_server'
require_relative 'url_logger'

APP_DOMAIN = 'www.kudoso.com'
ROUTER_SERVER_DOMAIN = 'router.kudoso.com'
$router_mac_address = nil

SOFTWARE_VERSION = File.read(File.dirname(__FILE__) + '/version.txt')

# ALWAYS_ALLOW_URLS = [
#   # When signing into a wifi network, apple tries to check this url
#   'apple.com/library/test/success.html',
#   'apple.com/',
#   APP_DOMAIN
# ]

ALWAYS_ALLOW_URLS = [
  "#{APP_DOMAIN}/sign_in",
  "#{APP_DOMAIN}/users/sign_in",
  "#{APP_DOMAIN}/prohibited",
  "#{APP_DOMAIN}/users/password/new",
  "#{APP_DOMAIN}/users/password",
  "#{APP_DOMAIN}/install_certs",
  "#{APP_DOMAIN}/assets",
  "beacon-4.newrelic.com",
  "d1ros97qkrwjf5.cloudfront.net",
  "khanacademy.org",
  "khan-academy.appspot.com",
   # temp solution, for kahnacademby embeded videos loading
  "youtube.com/embed",
  "youtube.com/videoplayback"
].map {|url| url.gsub(/^www[.]/, '') }


class Client < EventMachine::Connection
  def initialize(proxy, ssl)
    @proxy = proxy
    @ssl = ssl
  end

  def post_init
    # puts "Start TSL"
    # @post_init_called = true
    start_tls(verify_peer: false, ssl_version: :SSLv3) if @ssl
    # start_tls(verify_peer: false, :private_key_file => 'certs/exceptionhub.key', :cert_chain_file => 'certs/exceptionhub.pem', ssl_version: :SSLv3)
  end

  # def ssl_handshake_completed
  #   # @ssl_handshake_completed_called = true
  #   # close_connection
  # end

  def receive_data(data)
    # puts "Data: #{data}"
    @proxy.send_data(data)
  end

  def unbind
    # puts "Closed from Client"
    @proxy.close_connection_after_writing
  end
end

class Proxy < EventMachine::Connection
  def initialize(ssl)
    @ssl = ssl
  end

  def post_init
    @users_port, @users_ip = Socket.unpack_sockaddr_in(get_peername)
    # puts "user connected from #{@users_ip}:#{@users_port}"

    if true
      # pdata = get_sock_opt(Socket::SOL_IP, 19)
      pdata = get_sock_opt(Socket::SOL_IP, 80)

      _, port, a1, a2, a3, a4 = pdata.unpack("nnCCCC")
      @ip = "#{a1}.#{a2}.#{a3}.#{a4}"

      # puts "Connected to: #{@ip}:#{port}"
    else
      @ip = '50.56.91.35'
    end

    start_request
    start_ssl if @ssl
  end

  def start_ssl
    # private_key, cert_chain = Certificate.generate(@ip)
    # start_tls(verify_peer: false, :private_key_file => private_key, :cert_chain_file => cert_chain, ssl_version: :SSLv3)

    # private_key = File.dirname(__FILE__) + "/certs/domains/#{@ip}.key"
    # cert_chain = File.dirname(__FILE__) + "/certs/domains/#{@ip}.pem"
    private_key = "/tmp/certs/domains/#{@ip}.key"
    cert_chain = "/tmp/certs/domains/#{@ip}.pem"

    # return

    if File.exists?(private_key) && File.exists?(cert_chain)
      # puts "From Cache"
      start_tls(verify_peer: false, :private_key_file => private_key, :cert_chain_file => cert_chain, ssl_version: :SSLv3)
    else
      # pause
      CertificateClient.lookup(@ip) do |key,pem|
        # puts "Lookup complete for #{@ip}"
        # puts "GOT: #{key.inspect}\n\n\n#{pem.inspect}"

        unless File.exists?('/tmp/certs/domains')
          `mkdir -p /tmp/certs/domains`
        end

        # puts private_key
        # puts cert_chain
        # In some cases, the dns resolves, but the remote https server isn't
        # running, so we don't start tls since we don't have valid key/pem files
        if key.strip != '---' && pem.strip != '---'
          File.open(private_key, 'w') {|f| f.write(key) }
          File.open(cert_chain, 'w') {|f| f.write(pem) }

          # puts "start tls"
          start_tls(verify_peer: false, :private_key_file => private_key, :cert_chain_file => cert_chain, ssl_version: :SSLv3)
        end
        # puts "Start SSL"
        # resume
      end
    end
  end
  #
  # def ssl_verify_peer cert
  #   puts "veryfying client certificate: #{cert.inspect}"
  #   true  # TODO: Inspect the cert and reply false when invalid.
  # end
  # def ssl_handshake_completed
  #   puts "ssl completed, certificate: #{get_peer_cert.inspect}"
  # end

  def redirect_if_requested
    if @redirect_url
      # puts "Redirect To: #{@redirect_url}"


      content = <<-END
<HTML><HEAD><meta http-equiv="content-type" content="text/html;charset=utf-8">
<TITLE>307 Temporary Redirect</TITLE></HEAD><BODY>
<H1>307 Temporary Redirect</H1>
The document has moved
<A HREF="#{@redirect_url}">here</A>.
</BODY></HTML>
END

      content = content.strip

      str = <<-END
HTTP/1.1 307 Temporary Redirect
Location: #{@redirect_url}
Content-Type: text/html; charset=UTF-8
Cache-Control: public, max-age=0
Connection: Close
Content-Length: #{content.size}

#{content}
      END

      send_data((str.strip + "\n\n").gsub(/\n/, "\r\n"))
      @redirect_url = nil

      # puts "Close Connection"
      # self.close_connection_after_writing
    end
  end

  # Called at the completion of the previous request (but before the response)
  # Sets things up for a new request
  def start_request
    redirect_if_requested

    @buffer = ''
    @headers = {}
    @state = :header
    @content_length = nil
    @content_seen = 0
  end

  def receive_data(data)
    # puts "Data: #{data}\n------------"
    @buffer << data

    if @state == :header

      end_of_headers = @buffer.index("\r\n\r\n")
      if end_of_headers
        header_data = @buffer[0...end_of_headers]
        # puts "HEADER DATA: #{header_data.inspect}"
        @buffer = @buffer[(end_of_headers+4)..-1]

        # We have reached the end of the headers
        # /\r?\n\r?/
        header_data.split("\n").map.with_index do |line,line_number|
          line = line.strip

          if line_number == 0
             @request = line
             @method, @url, @protocols = @request.split(' ')
             # puts "#{@host}#{@url}"
          else
            colon_loc = line.index(':')
            name = line[0..(colon_loc-1)]
            value = line[(colon_loc+1)..-1]
            if value
              @headers[name] = value.strip
            end
          end
        end

        @host = @headers['Host']

        # puts "HEADER DATA----#{@headers.inspect}---"

        connect_to_remote
      end
    end

    if @state == :method_body
      # Assume state == :method_body
      @content_seen += @buffer.size
      # puts "Send: ---#{@buffer.inspect}---"
      @client.send_data(@buffer) if @client
      @buffer = ''

      if @content_seen >= @content_length
        start_request
      end
    end
  end

  # Called when the headers have been processed and we want to start forwarding
  # to the other server
  def connect_to_remote
    check_valid_url do |track_url, user_id, allowed, url|
      # Log the url
      UrlLogger.log_url(user_id, allowed, url) if track_url


      unless @redirect_url
        unless @client
          # puts "Make connection to #{@ip} from #{self.object_id} - #{EM.connection_count}"
          @client = EventMachine::connect(@ip, @ssl ? 443 : 80, Client, self, @ssl)
        end

        send_request
      end

      # If the content length was specified, that means there is a request body
      # from a post (or put, etc..) request.  We should put it into a state
      # to continue receiving the rest of the body, then make the request
      if @headers['Content-Length']
        @content_length = @headers['Content-Length'].to_i
        # puts "Set content length: #{@content_length}"# -- #{@headers.inspect}"
        @state = :method_body
      else
        # Otherwise, we've passed everything we need to pass, setup for another
        # request
        start_request
      end
    end
  end


  def stylesheet_import?(url_ext, referer_ext)
    if url_ext && referer_ext
      # puts "#{url_ext} vs #{referer_ext}"

      if referer_ext == 'css' && ['jpg', 'jpeg', 'png', 'gif'].include?(url_ext)
        return true
      end
    end
    return false
  end

  # Should this page be allowed before a user logs in
  # def login_allow?(match_url)
  #   match_url.gsub!(/^www[.]/, '').downcase!
  #   ALWAYS_ALLOW_URLS.each do |url|
  #     if match_url[/^#{url}/]
  #       return true
  #     end
  #   end
  # end

  def always_allow?(match_url, url_ext)
    # Always allow .ico since they don't set referer
    return true if url_ext && ['ico'].include?(url_ext)

    return false
  end

  def asset_url?(url_ext)
    return %w{jpg jpeg png gif css js ico swf xml}.include?(url_ext)
  end

  def request_for_asset?
    accepts = @headers['Accept'] || 'text/html'

    if accepts !~ /text\/html/
      return true
    else
      return false
    end
  end

  def ajax_request?
    return @headers['Origin']
  end

  # def activities_url(url, referer)
  #   # Here we want to allow youtube to be loaded from other domains if its a
  #   # referer from an iframe
  #   puts "Host: #{url} -- : #{referer}"
  #   return true if url =~ /([a-z]+[.])?youtube.com/ && referer[0...15] == 'khanacademy.org'
  #   return true if url == 's.youtube.com/stream_204' && referer =~ /^youtube.com\/embed\//
  #
  #   return false
  # end

  # Make sure where we're connecting is allowed, return a new ip, url
  def check_valid_url(&block)
    # Setup urls
    full_url = "#{@host}#{@url}"
    # puts "Check Valid: #{url}"
    referer = @headers['Referer']

    # Remove protocol and www
    url = full_url.gsub(/^https?[:]\/\//, '').gsub(/^www[.]/, '').gsub(/[?].*$/, '')
    referer = referer.gsub(/^https?[:]\/\//, '').gsub(/^www[.]/, '').gsub(/[?].*$/, '') if referer

    # Get url extension
    url_last_dot = url.rindex('.')
    url_ext = url_last_dot ? url[(url_last_dot+1)..-1].downcase : nil

    if referer
      # Get referer extension
      referer_last_dot = referer.rindex('.')
      referer_ext = referer_last_dot ? referer[(referer_last_dot+1)..-1].downcase : nil

      if stylesheet_import?(url_ext, referer_ext)
        # File is being imported from stylesheet, referer will point to stylesheet
        yield(false)
        return
      end
    end

    # Check to see if this url is in the always allowed
    if always_allow?(url, url_ext) || (referer && always_allow?(referer, referer_ext))
      yield(false)
      return
    end


    IpToMac.lookup(@users_ip) do |mac, name|
      MacToUserId.lookup(mac) do |user_id|
        # If there is no user id, that means the user hasn't logged in before on
        # this device and we should redirect them to a login:
        if !user_id || user_id == -1
          # puts "Invalid URL: #{@host}#{@url} -- #{referer}"

          UserIdToUrlFilter.valid_url?(user_id, url) do |valid|
            unless valid
              redirect_to_login(mac, name, full_url)
            end
            yield(false)
          end
        else

          asset_request = asset_url?(url_ext) || request_for_asset? || ajax_request?
          UserIdToUrlFilter.valid_url?(user_id, url) do |valid|
            if valid
              # Main url is valid, continue
              yield(!asset_request, user_id, true, url)
            else
              # Main url is not valid
              if referer && referer.size > 0
                #
                # # Check some special sites to handle things like youtube form khan
                # if false && activities_url(url, referer)
                #   yield(true, user_id, true, url)
                # else

                  # But we have a referer for the request
                  UserIdToUrlFilter.valid_url?(user_id, referer) do |valid|
                    if valid
                      # Referer is on a valid domain, lets check to make sure
                      # that the file being loaded is an asset (not another site)
                      if !asset_request
                        # Disallow because this url is another site, not an asset
                        puts "Disallow3: #{url} -- #{@headers.inspect}"
                        redirect_to_not_allowed
                        yield(true, user_id, true, url)
                      else
                        # Url is an asset
                        yield(false, user_id, true, url)
                      end
                    else
                      # The url being loaded is not allowed or the referer
                      puts "Disallow: #{url} -- #{referer}"
                      redirect_to_not_allowed
                      yield(!asset_request, user_id, false, url)
                    end
                  end
                # end
              else
                puts "Disallow2: #{url} -- #{referer}"# -- #{UserIdToUrlFilter.instance_variable_get('@cache')[user_id]}"

                # Invalid main url and no referrer
                redirect_to_not_allowed
                yield(!asset_request, user_id, false, url)
              end
            end
          end
        end
      end
    end
  end

  def redirect_to_login(mac, name, url)
    puts "Trying #{url}, but need to login"
    if $router_mac_address && mac
      @redirect_url = "http://#{APP_DOMAIN}/sign_in?router_mac_address=#{HttpRequest.url_escape($router_mac_address)}&mac_address=#{HttpRequest.url_escape(mac)}&ip=#{@users_ip}&name=#{name}&url=#{HttpRequest.url_escape(url)}"
    end
  end

  def redirect_to_not_allowed
    @redirect_url = "http://#{APP_DOMAIN}/prohibited"
  end

  def send_request
    @client.send_data("#{@method} #{@url} #{@protocols}\r\n")
    @headers.each_pair do |name, value|
      @client.send_data("#{name}: #{value}\r\n")
    end

    # puts "\r\n"
    @client.send_data("\r\n")
  end

  def unbind
    # puts "Closed from Proxy"
    @client.close_connection_after_writing if @client
  end

end


# First get mac for router
IpToMac.get_router_mac_address

Thread.abort_on_exception = true
EM.epoll = true
EventMachine.run do
  sleep 2

  puts "----- Booting #{SOFTWARE_VERSION} ---------------------------------------"

  puts "Setup IP Tables"
  UserIdToUrlFilter.update_ip_tables

  # Scan network devices
  puts "Update Ip2mac"
  IpToMac.update(true) do
    # Start once we get the router mac address

    puts "Starting Router Software on #{$router_mac_address}"
    # Start https
    puts "Start Https"
    EM.start_server '0.0.0.0', 8080, Proxy, true

    # Start http
    puts "Start Http"
    EM.start_server '0.0.0.0', 8081, Proxy, false

    # Listen for cache clear requests
    CacheServer.connect

    # Start admin http server
    AdminServer.start

    # Start logging urls to the server
    UrlLogger.start
  end
end