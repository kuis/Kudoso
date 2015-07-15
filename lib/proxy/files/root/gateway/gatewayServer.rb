# require 'pry'
require 'webrick'
require 'stringio'

include WEBrick

class FileUploadServlet < HTTPServlet::AbstractServlet
  def do_POST(req, res)
    filedata = req.query["filename"]
    if filedata.nil?
      res.set_redirect HTTPStatus::TemporaryRedirect, "/upload_fail.rhtml"
    else
      f = File.open("/tmp/firmware.bin", "wb")
      f.syswrite filedata
      f.close
      res.set_redirect HTTPStatus::TemporaryRedirect, "/upload_success.rhtml"
    end
  end
end

server = WEBrick::HTTPServer.new :Port => 1234
HTTPUtils::DefaultMimeTypes.store('rhtml', 'text/html')
server.mount "/",HTTPServlet::FileHandler, "./html"
server.mount "/upload", FileUploadServlet
trap('INT') { server.stop }
server.start
