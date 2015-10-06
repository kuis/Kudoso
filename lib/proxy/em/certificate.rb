require 'openssl'
require 'socket'

# https://github.com/mitmproxy/mitmproxy/blob/master/docs/howmitmproxy.rst

class Certificate
  KEY_NAME = 'root'
  def self.generate(host)
    @cache ||= {}

    if @cache[host]
      return *@cache[host]
    end

    puts "Generate Certificate: #{host.inspect}"

    port = 443

    socket = TCPSocket.new(host, port)

    ssl = OpenSSL::SSL::SSLSocket.new(socket)
    ssl.sync_close = true
    c = ssl.connect

    cert = c.peer_cert

    name = cert.subject.to_s
    socket.close

    # puts name

    subject_properties = Hash[name.split(/\//).map {|s| s.split(/[=]/) }.reject {|s| s.size != 2 }]
    domain = subject_properties['CN']

    #we use a previously generated root ca
    root_key = OpenSSL::PKey::RSA.new File.read(File.dirname(__FILE__) + "/certs/#{KEY_NAME}.key")
    root_ca = OpenSSL::X509::Certificate.new File.read(File.dirname(__FILE__) + "/certs/#{KEY_NAME}.pem")

    #generate the forged cert
    key = OpenSSL::PKey::RSA.new 1024 # was 2048
    new_cert = OpenSSL::X509::Certificate.new
    new_cert.version = 2#3 # was 2
    new_cert.serial = Random.rand(10000)

    # values = [{ 'C' => 'US'},
    #           {'ST' => 'SomeState'},
    #           { 'L' => 'SomeCity'},
    #           { 'O' => 'Organization'},
    #           {'OU' => 'Unit'},
    #           {'CN' => "exceptionhub.com"}]
    #
    # name = values.collect{ |l| l.collect { |k, v| "/#{k}=#{v}" }.join }.join

    new_cert.subject = cert.subject#OpenSSL::X509::Name.parse(name)
    new_cert.issuer = root_ca.subject # root CA is the issuer
    new_cert.public_key = key.public_key
    new_cert.not_before = Time.now - (24*60*60*30)
    new_cert.not_after = new_cert.not_before + 1 * 365 * 24 * 60 * 60 # 1 years validity
    ef = OpenSSL::X509::ExtensionFactory.new new_cert, root_ca
    new_cert.extensions = [
      # ef.create_ext("keyUsage","digitalSignature", true),
      ef.create_ext("keyUsage","keyEncipherment,dataEncipherment,digitalSignature", true),
      ef.create_ext("subjectKeyIdentifier","hash",false),
      ef.create_ext("basicConstraints","CA:FALSE",false)
    ]

    extension_data = Hash[cert.extensions.to_a.map {|ext| [ext.oid, ext.value] }]

    # puts "EXT DATA: " + extension_data.inspect
    #
    #
    # extension_data['subjectKeyIdentifier'] = 'hash'
    #
    # extension_data.delete('authorityKeyIdentifier')
    # extension_data.delete('crlDistributionPoints')
    # extension_data.delete('authorityInfoAccess')
    # extension_data.delete('certificatePolicies')
    #
    # extension_data.each_pair do |key,value|
    #   new_cert.add_extension ef.create_ext(key, value)
    # end
    #
    # puts "FINAL EXT DATA: " + extension_data.inspect

    if extension_data['subjectAltName']
      # puts "ASSIGN subjectAltName: #{extension_data['subjectAltName'].inspect}"
      new_cert.add_extension ef.create_ext("subjectAltName", extension_data['subjectAltName'])
    end

    if extension_data['keyUsage']
      puts "ASSIGN keyUsage: #{extension_data['keyUsage'].inspect}"
      # ef.create_ext("keyUsage", extension_data['keyUsage'])
    end

    # new_cert.add_extension ef.create_extension("authorityKeyIdentifier", "keyid:always,issuer:always")

    # OpenSSL::Digest::SHA256.new
    # new_cert.sign(root_key, OpenSSL::Digest::SHA256.new)
    new_cert.sign(root_key, OpenSSL::Digest::SHA1.new)

    #fill out the context
    ctx = OpenSSL::SSL::SSLContext.new
    ctx.key = key
    ctx.cert = new_cert
    ctx.ca_file = File.dirname(__FILE__) + "certs/#{KEY_NAME}.pem"

    File.open(File.dirname(__FILE__) + "/certs/domains/#{domain}.pem", "wb") { |f| f.print ctx.cert }
    File.open(File.dirname(__FILE__) + "/certs/domains/#{domain}.key", "wb") { |f| f.print ctx.key }

    puts "Generated"
    @cache[host] = [File.dirname(__FILE__) + "/certs/domains/#{domain}.key", File.dirname(__FILE__) + "/certs/domains/#{domain}.pem"]
    return *@cache[host]
  end

end