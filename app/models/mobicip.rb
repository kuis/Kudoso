class Mobicip
  def initialize
    @client_id = "MobicipDev5"
    @host = "https://portal.mobicip.net"
  end

  def prepare_request(xmlString, token='NOTOKEN')
    key = "F3OA4V7Q213MOP1Z"
    md5 = Digest::MD5.new
    md5.update token + key + xmlString
    request = "<mwsRequest><string>#{xmlString.encode(:xml => :text)}</string><checksum>#{md5.to_s}</checksum></mwsRequest>"
  end

end