class Plug < ActiveRecord::Base

  belongs_to :device
  validates_uniqueness_of :mac_address
  validates_format_of :mac_address, with: %r(\A([0-9a-f]{2}[:]){5}([0-9a-f]{2})\z)

  before_create :generate_secure_key

  before_save do
    self.mac_address = self.mac_address.downcase
  end

  def touch(ip)
    self.last_seen = Time.now
    self.last_known_ip = ip
    self.save!
  end

  private

  def generate_secure_key
    self.secure_key = SecureRandom.hex(20)
  end

end
