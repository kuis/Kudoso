class DeviceCategory < ActiveRecord::Base
  has_many :device_types, dependent: :nullify
  has_many :family_device_categories, dependent: :destroy

  validates_presence_of :name, :description
end
