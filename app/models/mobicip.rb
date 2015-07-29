

class Mobicip
  require 'rest-client'

  def initialize(target, family)
    @client_id = "5"
    #@target = "https://portal.mobicip.net/api/#{target}"
    @target = "https://kudoso.mobicip.net/api/#{target}"
    @request = nil
    @xmlString = nil
    @family = family
    @result = nil
  end

  def self.create_account(family)
    if family.mobicip_password.nil?
      family.update_attribute(:mobicip_password, SecureRandom.hex(18))
    end
    mobicip = Mobicip.new('user/createUser', family)
    mobicip.xmlString  = '<?xml version="1.0" encoding="UTF-8"?>' + mobicip.create_user_xml.to_s
    mobicip.request = mobicip.prepare_request(mobicip.xmlString, (family.mobicip_token.present? ? family.mobicip_token : 'NOTOKEN') )
    mobicip.result = mobicip.post_request
    if mobicip.result.elements["response/status/code"].try(:text) == '000'
      mobicip = Mobicip.login(family)
      mobicip.list_all_profiles
      def_profile_id = mobicip.result.elements["response/profiles/profile/id"].first
      if def_profile_id
        parent = family.members.first
        parent.update_attributes({mobicip_profile: def_profile_id, mobicip_filter: family.default_filter })
        mobicip.update_profile(parent, mobicip.filter_id?(family.default_filter) )
      end

    else
      # TODO: Raise error if token is null or result is error
    end
    return mobicip
  end

  def self.login(family)
    mobicip = Mobicip.new('session/login', family)
    mobicip.xmlString  = '<?xml version="1.0" encoding="UTF-8"?>' + mobicip.create_login_xml.to_s
    mobicip.request = mobicip.prepare_request(mobicip.xmlString, (family.mobicip_token.present? ? family.mobicip_token : 'NOTOKEN') )
    mobicip.result = mobicip.post_request
    family.update_attribute(:mobicip_token, mobicip.result.elements["response/session/token"].text)
    # TODO: Raise error if token is null or result is error
    return mobicip
  end

  def logout!
    @target = "https://kudoso.mobicip.net/api/session/logout"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_token_xml.to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      @family.update_attribute(:mobicip_token, nil)
    else
      # TODO: Raise error if token is null or result is error
    end

    return true
  end

  def list_all_categories
    @target = "https://kudoso.mobicip.net/api/filterconfig/listAllCategories"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_token_xml.to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
  end

  def list_filter_levels
    @target = "https://kudoso.mobicip.net/api/filterconfig/listFilterLevels"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_token_xml.to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
  end

  def list_all_profiles
    @target = "https://kudoso.mobicip.net/api/user/listAllProfiles"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_token_xml.to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
  end

  def register_device(device)

  end

  def create_profile(member, filter_level_id)
    return false if member.nil? || filter_level_id.blank?
    @target = "https://kudoso.mobicip.net/api/user/createProfile"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_profile_xml(member.username, filter_level_id).to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      member.update_attribute(:mobicip_profile, @result.elements["response/profile/id"].text)
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end

  def update_profile(member, filter_level_id)
    return false if member.nil? || filter_level_id.blank?
    @target = "https://kudoso.mobicip.net/api/user/updateProfile"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_profile_xml(member.username, filter_level_id, member.mobicip_profile).to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end

  def delete_profile(member)
    return false if member.nil? || member.mobicip_profile.blank?
    @target = "https://kudoso.mobicip.net/api/user/deleteProfile"
    @xmlString = '<?xml version="1.0" encoding="UTF-8"?>' + self.create_profile_xml(member.username, nil, member.mobicip_profile).to_s
    @request = self.prepare_request(@xmlString, (@family.mobicip_token.present? ? @family.mobicip_token : 'NOTOKEN') )
    @result = self.post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      member.update_attribute(:mobicip_profile, nil)
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end



  ##################################################
  attr_accessor :xmlString, :request, :result, :target

  def prepare_request(xmlstring, token)
    puts "XML: " + xmlstring
    encodedXml = xmlstring.encode(:xml => :text)
    key = "F3OA4V7Q213MOP1Z"
    md5 = Digest::MD5.new
    md5.update( token + key + @xmlString )  # do checksum on un-encoded XML string
    "<mwsRequest><string>#{encodedXml}</string><checksum>#{md5.to_s}</checksum></mwsRequest>"
  end

  def post_request

    puts "URI: " + @target
    puts "Request:\n\n" + @request + "\n\n"
    begin
      res = RestClient.post @target, @request, content_type: "application/xml", accept: "application/xml"
      #logger.debug res.inspect
      responseDoc = REXML::Document.new(res.body)
      # TODO: error checking for the XML created
      innerDoc =  REXML::Document.new( REXML::Text.new(responseDoc.elements["mwsResponse"].elements["string"].text, false, nil, true).value)
      puts "Response:\n\n" + innerDoc.to_s + "\n\n"
    rescue => e
      puts "Response:\n\n" + e.inspect + "\n\n"
      innerDoc = REXML::Document.new()
    end

    return innerDoc
  end


#   The server to use for integration with Mobicip webservice has been setup.
#
#   http://kudoso.mobicip.net (website)
#   http://kudoso.mobicip.net/api (webservice)
#
#   API's added/modified:
#
# 1. createUser - Modified: captcha and device related fields are optional
# 2. login - Modified: device related fields are optional
# 3. getMDMProfileForHash - Added
#     EndPoint: https://kudoso.mobicip.net/api/user/getMDMProfileForHash
#     (Note: the end point will move around a little bit, we will let you know if it does)
#
# 4. registerDevice - Added
#     EndPoint: https://kudoso.mobicip.net/api/user/getMDMProfileForHash
#     There are some parameter naming convention mismatch between document and implementation. The actual parameters should be
#     osVersion, buildVersion, productName, modelName, deviceName
#
# 5. getTokenForDevice - Added
#     EndPoint: https://kudoso.mobicip.net/api/device/registerDevice
#
# 6. getServerList - Added
#     EndPoint: https://kudoso.mobicip.net/api/user/getServerList
#     (Note: the end point will move around a little bit, we will let you know if it does)
#
# 7. lockDeviceToApp - Added:but stubbed out, will enable it within a week
#     EndPoint: https://kudoso.mobicip.net/api/device/lockDeviceToApp
#     Naming convention mismatch: actual parameter -> appIdentifier
#
# 8. unlockDeviceFromApp - Added:but stubbed out, will enable it within a week
#     EndPoint: https://kudoso.mobicip.net/api/device/unlockDeviceFromApp






  def create_user_xml(doc = REXML::Document.new)
    doc.add_element("request") if doc.elements["request"].nil?
    doc.elements["request"].add_element("account")
    doc.elements["request"].elements["account"].add_element "user"
    doc.elements["request"].elements["account"].elements["user"].add_element "email"
    doc.elements["request"].elements["account"].elements["user"].elements["email"].add_text "test_family_#{@family.id}@kudoso.com"
    doc.elements["request"].elements["account"].elements["user"].add_element "password"
    doc.elements["request"].elements["account"].elements["user"].elements["password"].add_text @family.mobicip_password
    doc.elements["request"].elements["account"].elements["user"].add_element "passwordConfirmation"
    doc.elements["request"].elements["account"].elements["user"].elements["passwordConfirmation"].add_text @family.mobicip_password
    doc.elements["request"].elements["account"].add_element "acceptTerms"
    doc.elements["request"].elements["account"].elements["acceptTerms"].add_text "true"
    doc.elements["request"].elements["account"].add_element "location"
    doc.elements["request"].elements["account"].elements["location"].add_text "America"
    doc.elements["request"].elements["account"].add_element "receiveNewsletters"
    doc.elements["request"].elements["account"].elements["receiveNewsletters"].add_text "false"
    doc.elements["request"].add_element("client")
    doc.elements["request"].elements["client"].add_element "id"
    doc.elements["request"].elements["client"].elements["id"].add_text @client_id
    doc.elements["request"].elements["client"].add_element "version"
    doc.elements["request"].elements["client"].elements["version"].add_text "1.0"
    doc
  end

  def create_login_xml(doc = REXML::Document.new)
    doc.add_element("request") if doc.elements["request"].nil?
    doc.elements["request"].add_element("user")
    doc.elements["request"].elements["user"].add_element "email"
    doc.elements["request"].elements["user"].elements["email"].add_text "family_#{@family.id}@kudoso.com"
    doc.elements["request"].elements["user"].add_element "password"
    doc.elements["request"].elements["user"].elements["password"].add_text @family.mobicip_password
    doc.elements["request"].add_element("client")
    doc.elements["request"].elements["client"].add_element "id"
    doc.elements["request"].elements["client"].elements["id"].add_text @client_id
    doc.elements["request"].elements["client"].add_element "version"
    doc.elements["request"].elements["client"].elements["version"].add_text "1.0"
    doc
  end

  def create_token_xml(doc = REXML::Document.new)
    doc.add_element("request") if doc.elements["request"].nil?
    doc.elements["request"].add_element("session")  if doc.elements["request.session"].nil?
    doc.elements["request"].elements["session"].add_element "token"
    doc.elements["request"].elements["session"].elements["token"].add_text (@family.mobicip_token || 'NOTOKEN')
    doc
  end

  def create_profile_xml(name = nil, filter_level_id = nil, profile_id = nil)
    # The default settings for this filter level are: 4) Monitor, 5) Strict, 6) Moderate, 7) Mature
    doc = create_token_xml
    doc.elements["request"].add_element("profile")
    if profile_id
      doc.elements["request/profile"].add_element("id")
      doc.elements["request/profile/id"].add_text profile_id.to_s
    end
    if name
      doc.elements["request/profile"].add_element("name")
      doc.elements["request/profile/name"].add_text name.to_s
    end
    if filter_level_id
      doc.elements["request/profile"].add_element("filterLevelId")
      doc.elements["request/profile/filterLevelId"].add_text filter_level_id.to_s
    end
    doc
  end

  def filter_id?(filter_name)
    filters = %w(monitor strict moderate mature)
    id = filters.index(filter_name.downcase)
    id += 4 if id
    return id
  end

  def filter?(filter_id)
    filters = %w(monitor strict moderate mature)
    return filters[filter_id.to_i - 4]
  end




end