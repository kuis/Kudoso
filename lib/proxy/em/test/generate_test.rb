require 'openssl'

#we use a previously generated root ca
root_key = OpenSSL::PKey::RSA.new File.open("../certs/root.key")
root_ca = OpenSSL::X509::Certificate.new File.open("../certs/root.pem")

#generate the forged cert
key = OpenSSL::PKey::RSA.new 2048
cert = OpenSSL::X509::Certificate.new
cert.version = 2
cert.serial = Random.rand(1000)


values = [{ 'C' => 'US'},
          {'ST' => 'SomeState'},
          { 'L' => 'SomeCity'},
          { 'O' => 'Organization'},
          {'OU' => 'Unit'},
          {'CN' => "exceptionhub.com"}]

name = values.collect{ |l| l.collect { |k, v| "/#{k}=#{v}" }.join }.join


cert.subject = OpenSSL::X509::Name.parse(name)
cert.issuer = root_ca.subject # root CA is the issuer
cert.public_key = key.public_key
cert.not_before = Time.now
cert.not_after = cert.not_before + 1 * 365 * 24 * 60 * 60 # 1 years validity
ef = OpenSSL::X509::ExtensionFactory.new cert, root_ca
ef.create_ext("keyUsage","digitalSignature", true)
ef.create_ext("subjectKeyIdentifier","hash",false)
ef.create_ext("basicConstraints","CA:FALSE",false)
cert.sign(root_key, OpenSSL::Digest::SHA256.new)

#fill out the context
ctx = OpenSSL::SSL::SSLContext.new
ctx.key = key
ctx.cert = cert
ctx.ca_file="certs/root.pem"

File.open("../certs/test.pem", "wb") { |f| f.print ctx.cert }
File.open("../certs/test.key", "wb") { |f| f.print ctx.key }

# puts ctx.cert
# puts '-----------------'
# puts ctx.key


# puts ctx.methods.inspect

# puts cert.to_pem.inspect

# puts "-----------------"

# File.open("certs/test.pem", "wb") { |f| f.print cert.to_pem }