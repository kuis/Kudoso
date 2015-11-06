class ActivityDevice < ActiveRecord::Base
  self.table_name = :activities_devices
  belongs_to :activity
  belongs_to :device
  has_one :member, through: :activity

  validates_presence_of :device, :activity
  validates :device_id, uniqueness: { scope: :activity_id }

end