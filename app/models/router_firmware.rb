class RouterFirmware < ActiveRecord::Base
  belongs_to :router_model
  has_many :routers

  validates_presence_of :url, :checksum, :version, :router_model
end
