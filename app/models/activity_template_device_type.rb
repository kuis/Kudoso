class ActivityTemplateDeviceType < ActiveRecord::Base
  belongs_to :activity_template
  belongs_to :device_type

  validates_presence_of :activity_template, :device_type

end
