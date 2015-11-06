class Activity < ActiveRecord::Base
  belongs_to :member                            # Family member who PERFORMED the activity, may be nil
  belongs_to :created_by, class_name: 'Member', foreign_key: 'created_by_id'  # Family member who CREATED the activity, required, allows tracking of anonymous access
  has_many :activity_devices, dependent: :destroy
  has_many :devices, through: :activity_devices
  has_one :family, through: :created_by
  belongs_to :activity_template
  has_many :details, class_name: 'ActivityDetail'

  validates_presence_of :created_by, :activity_template

  def anonymous?
    member.blank?
  end

  def start!
    if check_screen_time
      if self.start_time.blank?
        transaction do
          self.start_time = Time.now.localtime
          self.allowed_time = self.member.available_screen_time(self.start_time.to_date, self.devices.to_a )
          self.save
          self.devices.each do |device|
            device.update_attribute(:current_activity_id, self.id)
          end

        end
      else
        #raise error
        raise 'Activity was started previously, cannot start again!'
      end
    end

    self
  end

  def stop!
    if self.end_time.blank?
      transaction do
        self.update_attribute(:end_time, Time.now.localtime)
        self.devices.each do |device|
          device.update_attribute(:current_activity_id, nil)
        end
        # TODO: calc cost/reward and assign
      end
    else
      #raise error
      raise 'Activity was ended previously, cannot end again!'
    end
    self
  end

  def duration
    endtime = self.end_time || Time.now.localtime
    (endtime - self.start_time).ceil
  end


  private

  def check_screen_time
    max_time = member.available_screen_time
    used_time = member.used_screen_time
    if used_time >= max_time
      errors.add(:member, 'available screen time for today exceeded.')
    end
    self.devices.each do |device|
      device_time = member.screen_time(Time.now.localtime, device)
      device_used_time = member.used_screen_time(Time.now.localtime, device)
      if device_time == 0 || device_used_time >= device_time
        errors.add(:device, 'max screen time for today exceeded.')
      end
    end

    if errors.count > 0
      return false
    else
      return true
    end
  end

end
