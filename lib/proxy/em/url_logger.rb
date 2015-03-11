require_relative 'http_request'

class UrlLogger
  # Tracks a url, will be sent to tracking server every 30 seconds
  def self.log_url(user_id, allowed, url)
    puts "#{user_id} - #{allowed ? 'Allowed' : 'Blocked'} #{url}"
    @urls ||= []
    @urls << [user_id, allowed ? '1' : '0', url].join(":")
  end

  def self.start
    puts "Start Url Logger"
    # Every 30 seconds, check if we have urls to upload
    EventMachine.add_periodic_timer(30) do
      self.upload_urls
    end
  end

  def self.upload_urls
    @urls ||= []

    if @urls.size > 0
      # puts "Log Urls: #{@urls}"
      HttpRequest.post("http://#{APP_DOMAIN}/sites/", {'user_sites' => @urls.join("\n")}) do |response|
        # puts "RESPONSE: #{response.inspect}"
      end
    end

    @urls = []
  end

end