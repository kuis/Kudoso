require 'uri'
require 'net/http'

class HttpRequest
	def self.get(url)
    # puts "GET: #{url}"
		uri = URI.parse(url)


		yield(200, Net::HTTP.get(uri))
		return

		http = EventMachine::Protocols::HttpClient.request(
  		:host => uri.host,
  		:port => uri.port,
  		:request => uri.path,
  		:query_string => uri.query
		)

		puts "Path: #{uri.path}, #{uri.query}"
		http.callback do |response|
		  puts response.inspect
			yield(response[:status], response[:content])
		end
	end

	def self.post(url, query)
    # puts "POST: #{url} - #{query.inspect}"
		uri = URI.parse(url)

		http = EventMachine::Protocols::HttpClient.request(
  		:host => uri.host,
  		:port => uri.port,
  		:request => uri.path,
  		:verb => 'POST',
      # :query_string => query.to_a.map {|q| q.map {|v| HttpRequest.url_escape(v.to_s) }.join('=') }.join('&')#,
      :content => query.to_a.map {|q| q.map {|v| HttpRequest.url_escape(v.to_s) }.join('=') }.join('&'),
      :contenttype => 'application/x-www-form-urlencoded'
		)
		if block_given?
  		http.callback do |response|
  			yield(response[:status], response[:content])
  		end
		end
	end

	def self.url_escape(string)
	  string.gsub(/([^ a-zA-Z0-9_.-]+)/n) do
    '%' + $1.unpack('H2' * $1.size).join('%').upcase
    end.tr(' ', '+')
  end
end
