class RouterFirmware < ActiveRecord::Base
  belongs_to :router_model
  has_many :routers

  validates_presence_of  :checksum, :version, :router_model

  has_attached_file :firmware
  validates_attachment :firmware, content_type: { content_type: [ "application/octet-stream", "application/macbinary" ] }
  validates_attachment_file_name :firmware, matches: [/bin\Z/]

  validate :checksum do
    if firmware.exists? && checksum != firmware_fingerprint
      self.errors.add(:checksum, 'does not match uploaded file checksum')
    end
  end

  def url
    firmware.exists? ? firmware.url : ''
  end
end
