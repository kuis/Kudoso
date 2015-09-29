class Router < ActiveRecord::Base
  belongs_to :router_model
  belongs_to :router_firmware
  belongs_to :family

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

  def latest_firmware
    RouterFirmware.where(router_model_id: self.router_model_id).order('version desc').first
  end

  def generate_secure_key
    self.secure_key = SecureRandom.hex(32)
  end
end
