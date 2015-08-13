class Router < ActiveRecord::Base
  belongs_to :router_model
  belongs_to :router_firmware
  belongs_to :family

  validates_uniqueness_of :mac_address

  validates_format_of :mac_address, with: %r(\A([0-9A-F]{2}[:]){5}([0-9A-F]{2})\z)
  before_create :generate_device_token

  before_save do
    self.mac = self.mac.downcase
  end

  def touch(req)
    self.last_seen= Time.now
    self.last_known_ip=req.try(:remote_ip)
    self.save!
  end

  def latest_firmware
    self.latest_firmware.last
  end

  private

  def generate_secure_key
    self.secure_key = SecureRandom.hex(32)
  end
end
