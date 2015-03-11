gem 'certificate_authority'

require 'certificate_authority'
root = CertificateAuthority::Certificate.new
root.subject.common_name= "Kudoso SSL"
root.serial_number.number=1
root.key_material.generate_key
root.signing_entity = true
signing_profile = {"extensions" => {"keyUsage" => {"usage" => ["critical", "keyCertSign"] }} }
root.sign!(signing_profile)

File.open("../certs/root2.pem", "wb") { |f| f.print root.key_material.public_key }
File.open("../certs/root2.key", "wb") { |f| f.print root.key_material.private_key }



intermediate = CertificateAuthority::Certificate.new
intermediate.subject.common_name= "Kudoso SSL"
intermediate.serial_number.number=2
intermediate.key_material.generate_key
intermediate.signing_entity = true
intermediate.parent = root
signing_profile = {"extensions" => {"keyUsage" => {"usage" => ["critical", "keyCertSign"] }} }
intermediate.sign!(signing_profile)