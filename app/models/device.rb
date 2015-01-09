class Device < ActiveRecord::Base
  belongs_to :device_type
  belongs_to :family
  belongs_to :primary_member, class_name: 'Member'
  has_and_belongs_to_many :activities
  belongs_to :management_device, class_name: 'Device'

  validates_uniqueness_of :name
  validates_presence_of :device_type_id
  validates_presence_of :family_id

  before_create { self.uuid = SecureRandom.hex(24) }

  attr_readonly :uuid
end
