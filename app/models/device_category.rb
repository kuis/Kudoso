class DeviceCategory < ActiveRecord::Base
  has_many :device_types, dependent: :nullify

  validates_presence_of :name, :description
end
