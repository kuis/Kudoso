require_relative 'certificate'

class CertificateClient
  def self.lookup(hostname, &block)
    puts "Generating Local #{hostname}"

    key, pem = Certificate.generate(hostname)

    puts "Generated: #{hostname}"

    # puts "Key: #{key}, Pem: #{pem}"

    block.call(File.read(key), File.read(pem))
  end
end