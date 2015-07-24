class Device < ActiveRecord::Base
  belongs_to :device_type
  has_one :device_category, through: :device_type
  belongs_to :family
  belongs_to :primary_member, class_name: 'Member'
  has_many :activities, dependent: :nullify
  has_one :current_activity, class_name: 'Activity'
  belongs_to :management_device, class_name: 'Device', foreign_key: 'management_id', counter_cache: :managed_devices_count
  has_many :managed_devices, class_name: 'Device', foreign_key: 'management_id'
  has_many :screen_times
  has_many :commands

  validates_uniqueness_of :name, :uuid
  validates_presence_of :device_type_id, :device_type
  validates_presence_of :family_id

  before_create { self.uuid = SecureRandom.uuid }

  attr_readonly :uuid

  def current_member
    current_activity.try(:member)
  end

  def last_command(command_name)
    return nil if command_name.blank?

    command = self.commands.where("name = ? AND executed IS NOT TRUE AND sent IS NOT NULL", command_name).last
    command = self.commands.new(name: command_name) if command.nil?

    return command
  end
end
