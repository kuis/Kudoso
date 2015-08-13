class RouterFirmware < ActiveRecord::Base
  belongs_to :router_model
  has_many :routers
end
