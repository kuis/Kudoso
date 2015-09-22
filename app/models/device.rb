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
  has_one :plug
  has_many :app_devices, dependent: :destroy
  has_many :apps, through: :app_devices
  has_many :applogs, dependent: :destroy

  validates :name, uniqueness: { scope: :family_id }
  # validates_presence_of :uuid
  validates_uniqueness_of :uuid, blank: true
  # validates_presence_of :device_type_id, :device_type
  validates_presence_of :family_id, :family


  before_create do
    self.uuid = SecureRandom.uuid
    self.secure_key = SecureRandom.hex(32)
  end

  before_validation do
    self.name ||= self.mac_address
    self.name ||= self.wifi_mac
    if wifi_mac.present? && mac_address.nil?
      mac_address = wifi_mac
    end
  end

  attr_readonly :uuid

  validates :name, uniqueness: { scope: :family_id }, presence: true
  validates_uniqueness_of :uuid
  # validates_presence_of :device_type_id, :device_type
  validates_presence_of :family_id

  def current_member
    current_activity.try(:member)
  end

  def activity_end_time
    return nil if current_activity && current_activity.end_time
    if current_activity && current_activity.start_time
      current_activity.start_time.to_i + current_activity.allowed_time
    else
      nil
    end

  end

  def last_command(command_name)
    return nil if command_name.blank?

    command = self.commands.where("name = ? AND executed IS NOT TRUE AND sent IS NOT NULL", command_name).last
    command = self.commands.new(name: command_name) if command.nil?

    return command
  end

  def register_with_mobicip
    return true if self.udid.present?
    return false unless self.device_type.try(:os) == "iOS"
    mobicip = Mobicip.new
    result = mobicip.login(self.family)
    result = mobicip.getMDMProfileForHash(self) if result
    return result #this returns the url for the device to register with the MDM
  end

  def long_label
    "(#{self.id}) #{self.device_type.try(:name)} #{self.name}"
  end
end
