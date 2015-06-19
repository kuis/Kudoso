class Mobicip
  require 'rest-client'

  def initialize(token='NOTOKEN')
    @client_id = "MobicipDev5"
    @target = "https://portal.mobicip.net/api/"
    @request = nil
    @xmlString = nil
    @token = token
    prepare_request
  end

  def create_account(family)
    @target = @target + "users/createAccount"
    if family.mobicip_password.nil?
      family.update_attribute(:mobicip_password, SecureRandom.hex(18))
    end
    family_to_mobicip_createUser_xml(family)
    prepare_request
    result = post_request
  end

  private


  def prepare_request
    encodedXml = @xmlString.encode(:xml => :text)
    key = "F3OA4V7Q213MOP1Z"
    md5 = Digest::MD5.new
    md5.update @token + key + encodedXml
    @request = "<mwsRequest><string>#{encodedXml}</string><checksum>#{md5.to_s}</checksum></mwsRequest>"
  end

  def post_request
    res = RestClient.post @target, @request, content_type: "application/xml", accept: "application/xml"
    logger.debug res.inspect
    responseDoc = REXML::Document.new(res.body)
    # TODO: error checking for the XML created
    innerDoc =  REXML::Document.new( REXML::Text.new(responseDoc.elements["mwsResponse"].elements["string"].text, false, nil, true).value)
  end



  def family_to_mobicip_createUser_xml(family)
    doc = REXML::Document.new
    doc.add_element("request")
    doc.elements["request"].add_element("account")
    doc.elements["request"].elements["account"].add_element "user"
    doc.elements["request"].elements["account"].elements["user"].add_element "email"
    doc.elements["request"].elements["account"].elements["user"].elements["email"].add_text "family_#{family.id}@kudoso.com"
    doc.elements["request"].elements["account"].elements["user"].add_element "password"
    doc.elements["request"].elements["account"].elements["user"].elements["password"].add_text family.mobicip_password
    doc.elements["request"].elements["account"].elements["user"].add_element "passwordConfirmation"
    doc.elements["request"].elements["account"].elements["user"].elements["passwordConfirmation"].add_text family.mobicip_password
    doc.elements["request"].elements["account"].add_element "acceptTerms"
    doc.elements["request"].elements["account"].elements["acceptTerms"].add_text "true"
    doc.elements["request"].elements["account"].add_element "location"
    doc.elements["request"].elements["account"].elements["location"].add_text "America"
    doc.elements["request"].elements["account"].add_element "receiveNewsletters"
    doc.elements["request"].elements["account"].elements["receiveNewsletters"].add_text "false"
    doc.elements["request"].add_element("client")
    doc.elements["request"].elements["client"].add_element "id"
    doc.elements["request"].elements["client"].elements["id"].add_text "MobicipDev05"
    doc.elements["request"].elements["client"].add_element "version"
    doc.elements["request"].elements["client"].elements["version"].add_text "1.0"
    doc
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + doc.to_s
  end

end