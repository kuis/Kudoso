class RouterModel < ActiveRecord::Base
  has_many :router_firmwares
  has_many :routers
end
