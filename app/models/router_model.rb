class RouterModel < ActiveRecord::Base
  has_many :router_firmwares, dependent: :destroy
  has_many :routers
end
