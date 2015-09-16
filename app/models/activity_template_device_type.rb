class ActivityTemplateDeviceType < ActiveRecord::Base

  #########
  #
  # The purpose of this model is to associate an activity_template
  # with a device_type so that it shows up as a potential activity when
  # a child has this device.  This is especially useful for partner integrations
  # where we want to launch a specific application on a device.
  #
  #########

  belongs_to :activity_template
  belongs_to :device_type

  validates_presence_of :activity_template, :device_type

end
