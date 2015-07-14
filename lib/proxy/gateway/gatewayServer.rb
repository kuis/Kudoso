require 'pry'
require 'webrick'
include WEBrick

class KudosoGWServlet < HTTPServlet::AbstractServlet
  def do_GET(req,resp)
    # Split the path
    path = req.path.split('/')
    case path[1]
      when nil
        resp.body = "We're the root!"
        raise HTTPStatus::OK
      when "status"
        resp.body = "We're alive!"
        raise HTTPStatus::OK
      else
        puts "Not found: #{path.inspect}"
        raise HTTPStatus::NotFound
    end
  end
  def do_POST(req,resp)
    #collect params
    params = Hash.new
    req.query_string.split("&").each { |qHash| q =qHash.split("="); params["#{q[0]}"] = "#{q[1]}" }
    # Split the path
    path = req.path.split('/')
    case path[1]
      when "wireless"
        if params["ssid"].nil?
          resp.body = "Must supply the SSID parameter!"
          raise HTTPStatus::ClientError
        else
          resp.body = "We've got an SSID!"
          raise HTTPStatus::OK
        end


      else
        puts "Not found: #{path.inspect}"
        raise HTTPStatus::NotFound
    end

  end
end




server = WEBrick::HTTPServer.new :Port => 1234
server.mount "/", KudosoGWServlet
trap('INT') { server.stop }
server.start
