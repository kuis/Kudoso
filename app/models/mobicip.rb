

class Mobicip
  require 'rest-client'

  def initialize(token = 'NOTOKEN', target = nil)
    @client_id = "5"
    #@target = "https://portal.mobicip.net/api/#{target}"
    @api_base_uri  = "https://kudoso.mobicip.net/api"
    @request = nil
    @xmlstring = nil
    @token = token
    @result = nil
    @target = target.present? ? "#{@api_base_uri}/#{target}" : nil
  end

  #########################
  #
  # Mobicip Session Methods
  #

  def create_account(family)
    family.mobicip_password = SecureRandom.hex(18) if family.mobicip_password.blank?
    if family.mobicip_id.blank?
      family.mobicip_id = "#{Rails.env.production? ? '' : "#{Rails.env}_" }family_#{family.id}@kudoso.com"
    end

    @target = "#{@api_base_uri}/user/createUser"
    @xmlstring  = '<?xml version="1.0" encoding="UTF-8"?>' + create_user_xml(family).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      family.save
      @token = @result.elements["response/session/token"].text
      list_all_profiles
      def_profile_id = @result.elements["response/profiles/profile/id"].first
      if def_profile_id
        parent = family.primary_contact.member
        parent.update_attributes({mobicip_profile: def_profile_id, mobicip_filter: family.default_filter })
        update_profile(parent, filter_id?(family.default_filter) )
      end
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end
  end

  def login(family)
    @target = "#{@api_base_uri}/session/login"
    @xmlstring  = '<?xml version="1.0" encoding="UTF-8"?>' + create_login_xml(family).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      @token = @result.elements["response/session/token"].text
      family.update_attribute(:mobicip_token, @token  )
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end
  end

  def logout!
    @target = "#{@api_base_uri}/session/logout"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      @family.update_attribute(:mobicip_token, nil)
    else
      # TODO: Raise error if token is null or result is error
    end

    return true
  end

  #########################
  #
  # Mobicip Profile Methods
  #

  def listAllProfiles
    @target = "#{@api_base_uri}/user/listAllProfiles"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
  end

  def createProfile(member, filter_level_id)
    return true if member.mobicip_profile.present?
    return false if member.nil? || filter_level_id.blank?
    @target = "#{@api_base_uri}/user/createProfile"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_profile_xml(member.username, filter_level_id).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      member.update_attribute(:mobicip_profile, @result.elements["response/profile/id"].text)
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end

  def updateProfile(member, filter_level_id)
    return false if member.nil? || filter_level_id.blank?
    @target = "#{@api_base_uri}/user/updateProfile"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_profile_xml(member.username, filter_level_id, member.mobicip_profile).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end

  def deleteProfile(member)
    return false if member.nil? || member.mobicip_profile.blank?
    @target = "#{@api_base_uri}/user/deleteProfile"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_profile_xml(member.username, nil, member.mobicip_profile).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      member.update_attribute(:mobicip_profile, nil)
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end

  end

  def getServerList
    @target = "#{@api_base_uri}/user/getServerList"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      member.update_attribute(:mobicip_profile, nil)
      return true
    else
      # TODO: Raise error if token is null or result is error
      return false
    end
  end

  #########################
  #
  # Mobicip Device Methods
  #
  # Key workflow of iOS:
  #  1. Device created on Kudoso inlcudes UUID (maps to Mobicip profileHash)
  #  2. Kudoso calls getMDMProfileForHash to get Registration URL
  #  3. Device opens Registration URL in Safari which installs the MDM profile and device registers with MDM
  #  4. Mobicip calls Kudoso's deviceDidRegister API: POST /api/v1/devices/:uuid/deviceDidRegister
  #  5. Kudoso calls registerDevice with newly obtains UDID to associate device with user account
  #

  def registerDevice(device)
    @target = "#{@api_base_uri}/device/registerDevice"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + register_device_xml(device).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return true
    else
      # TODO: Raise error
      return false
    end
  end

  def listAllDevices
    @target = "#{@api_base_uri}/device/listAllDevices"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return true
    else
      # TODO: Raise error
      return false
    end
  end

  # Updates device, only device name is updateable
  def updateDevice(device)
    @target = "#{@api_base_uri}/device/updateDevice"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_device_xml(device).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return @result.elements["response/profile/data"].try(:text)
    else
      # TODO: Raise error
      return false
    end
  end

  def getMDMProfileForHash(device)
    @target = "#{@api_base_uri}/user/getMDMProfileForHash"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_mdm_xml(device).to_s
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return @result.elements["response/profile/data"].try(:text)
    else
      # TODO: Raise error
      return false
    end
  end

  def getTokenForDevice(device)
    @target = "#{@api_base_uri}/device/getMDMProfileForHash"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_device_xml(device, 1.day.to_i.to_s ).to_s  # expiry of 1 day
    @request = prepare_request
    @result = post_request
    if @result.elements["response/status/code"].try(:text) == '000'
      return @result.elements["response/profile/data"].try(:text)
    else
      # TODO: Raise error
      return false
    end
  end

  def lockDeviceToApp(device)
    @target = "https://kudoso.mobicip.net/api/device/lockDeviceToApp"
    #TODO
    return false
  end

  def unlockDeviceFromApp(device)
    @target = "https://kudoso.mobicip.net/api/device/unlockDeviceFromApp"
    #TODO
    return false
  end




  #########################
  #
  # Mobicip Filter Methods
  #

  def listAllCategories
    @target = "#{@api_base_uri}/filterconfig/listAllCategories"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
  end

  def listFilterLevels
    @target = "#{@api_base_uri}/filterconfig/listFilterLevels"
    @xmlstring = '<?xml version="1.0" encoding="UTF-8"?>' + create_token_xml.to_s
    @request = prepare_request
    @result = post_request
  end

  def listBlockedCategoriesForFilterLevel(filter_level_id)
    #TODO
    return false
  end

  def listCategoryOverridesForProfile(member)
    #TODO
    return false
  end

  def setCategoryOverridesForProfile(member, category_id)
    #TODO
    return false
  end

  def listUrlOverridesForProfile(member)
    #TODO
    return false
  end

  def addUrlOverrideForProfile(member, url)
    #TODO
    return false
  end

  def removeUrlOverrideForProfile(member, url)
    #TODO
    return false
  end

  def listPhraseOverridesForProfile(member)
    #TODO
    return false
  end

  def addPhraseOverrideForProfile(member, phrase)
    #TODO
    return false
  end

  def removePhraseOverrideForProfile(member, phrase_id)
    #TODO
    false
  end

  def getWhitelistOnlyModeForProfile(member)
    #TODO
    return false
  end

  def setWhitelistOnlyModeForProfile(member)
    #TODO
    return false
  end

  #########################
  #
  # Mobicip Unblocking Methods
  #

  def getUnblockRequestSettings
    #TODO
    return false
  end

  def updateUnblockRequestSettings
    #TODO
    return false
  end

  def listAllUnblockRequests
    #TODO
    return false
  end

  def updateUnblockRequest
    #TODO
    return false
  end

  #########################
  #
  # Mobicip Report Methods
  #

  def listAllReports
    #TODO
    return false
  end

  def getUsageGraph
    #TODO
    return false
  end

  def requestDownloadableReport
    #TODO
    return false
  end

  def getDownloadableReport
    #TODO
    return false
  end

  def getReportSummary
    #TODO
    return false
  end




  private


  def prepare_request
    puts "XML: " + @xmlstring
    encodedXml = @xmlstring.encode(:xml => :text)
    key = "F3OA4V7Q213MOP1Z"
    md5 = Digest::MD5.new
    md5.update( @token + key + @xmlstring )  # do checksum on un-encoded XML string
    "<mwsRequest><string>#{encodedXml}</string><checksum>#{md5.to_s}</checksum></mwsRequest>"
  end

  def post_request

    puts "URI: " + @target
    puts "Request:\n\n" + @request + "\n\n"
    begin
      res = RestClient.post @target, @request, content_type: "application/xml", accept: "application/xml"
      #logger.debug res.inspect
      puts "Raw Response: \n\n" + res.body + "\n\n"
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
#     EndPoint: #{@api_base_uri}/user/getMDMProfileForHash
#     (Note: the end point will move around a little bit, we will let you know if it does)
#
# 4. registerDevice - Added
#     EndPoint: #{@api_base_uri}/user/getMDMProfileForHash
#     There are some parameter naming convention mismatch between document and implementation. The actual parameters should be
#     osVersion, buildVersion, productName, modelName, deviceName
#
# 5. getTokenForDevice - Added
#     EndPoint: #{@api_base_uri}/device/registerDevice
#
# 6. getServerList - Added
#     EndPoint: #{@api_base_uri}/user/getServerList
#     (Note: the end point will move around a little bit, we will let you know if it does)
#
# 7. lockDeviceToApp - Added:but stubbed out, will enable it within a week
#     EndPoint: #{@api_base_uri}/device/lockDeviceToApp
#     Naming convention mismatch: actual parameter -> appIdentifier
#
# 8. unlockDeviceFromApp - Added:but stubbed out, will enable it within a week
#     EndPoint: #{@api_base_uri}/device/unlockDeviceFromApp






  def create_user_xml(family, doc = REXML::Document.new)
    doc.add_element("request") if doc.elements["request"].nil?
    doc.elements["request"].add_element("account")
    doc.elements["request"].elements["account"].add_element "user"
    doc.elements["request"].elements["account"].elements["user"].add_element "email"
    doc.elements["request"].elements["account"].elements["user"].elements["email"].add_text family.mobicip_id
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
    doc.elements["request"].elements["client"].elements["id"].add_text @client_id
    doc.elements["request"].elements["client"].add_element "version"
    doc.elements["request"].elements["client"].elements["version"].add_text "1.0"
    doc
  end

  def create_login_xml(family, doc = REXML::Document.new)
    doc.add_element("request") if doc.elements["request"].nil?
    doc.elements["request"].add_element("user")
    doc.elements["request"].elements["user"].add_element "email"
    doc.elements["request"].elements["user"].elements["email"].add_text family.mobicip_id
    doc.elements["request"].elements["user"].add_element "password"
    doc.elements["request"].elements["user"].elements["password"].add_text family.mobicip_password
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
    doc.elements["request"].elements["session"].elements["token"].add_text @token
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

  def create_device_xml(device, expiry = nil)
    doc = create_token_xml
    doc.elements["request"].add_element("device")
    doc.elements["request/device"].add_element("id")
    doc.elements["request/device/id"].add_text device.uuid
    doc.elements["request/device"].add_element("name")
    doc.elements["request/device/name"].add_text device.name
    if expiry
      doc.elements["request/device"].add_element("expiry")
      doc.elements["request/device/expiry"].add_text expiry
    end
    doc
  end

  def create_mdm_xml(device)
    doc = create_token_xml
    doc.elements["request"].add_element("hash")
    doc.elements["request/hash"].add_element("profileHash")
    doc.elements["request/hash/profileHash"].add_text device.uuid
    doc
  end


  def register_device_xml(device)
    doc = create_token_xml
    doc.elements["request"].add_element("hash")
    doc.elements["request/hash"].add_element("profileHash")
    doc.elements["request/hash/profileHash"].add_text device.uuid
    # doc.elements["request"].add_element("device")
    # doc.elements["request/device"].add_element("signature1")
    # doc.elements["request/device/signature1"].add_text device.udid
    # doc.elements["request/device"].add_element("signature2")
    # doc.elements["request/device/signature2"].add_text device.wifi_mac
    # doc.elements["request/device"].add_element("signature3")
    # doc.elements["request/device/signature3"].add_text device.uuid
    # doc.elements["request/device"].add_element("os_version")
    # doc.elements["request/device/os_version"].add_text device.os_version
    # doc.elements["request/device"].add_element("build_version")
    # doc.elements["request/device/build_version"].add_text device.build_version
    # doc.elements["request/device"].add_element("product_name")
    # doc.elements["request/device/product_name"].add_text device.product_name
    # doc.elements["request/device"].add_element("model_name")
    # doc.elements["request/device/model_name"].add_text device.device_type.name
    # doc.elements["request/device"].add_element("device_name")
    # doc.elements["request/device/device_name"].add_text device.device_name
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