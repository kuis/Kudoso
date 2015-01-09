class DeviceType < ActiveRecord::Base
  has_many :devices, dependent: :restrict_with_error
end
