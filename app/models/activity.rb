class Activity < ActiveRecord::Base
  belongs_to :member                            # Family member who PERFORMED the activity, may be nil
  belongs_to :created_by, class_name: 'Member'  # Family member who CREATED the activity, required, allows tracking of anonymous access
  belongs_to :family_activity
  belongs_to :device
  has_one :family, through: :created_by
  belongs_to :activity_type
  has_many :details, class_name: 'ActivityDetail'

  validates_presence_of :created_by, :family_activity_id

  validate :check_screen_time, on: :create

  def anonymous?
    member.blank?
  end

  def start!
    if self.start_time.blank?
      transaction do
        self.update_attribute(:start_time, Time.zone.now)
        self.device.update_attribute(:current_activity_id, self.id) if self.device.present?
      end
    else
      #raise error
      raise 'Activity was started previously, cannot start again!'
    end
  end

  def stop!
    if self.end_time.blank?
      transaction do
        self.update_attribute(:end_time, Time.zone.now)
        self.device.update_attribute(:current_activity_id, nil) if self.device.present?
      end
    else
      #raise error
      raise 'Activity was ended previously, cannot end again!'
    end
  end

  def duration
    endtime = self.end_time || Time.zone.now
    endtime - self.start_time
  end

  private

  def check_screen_time
    max_time = member.max_screen_time
    if self.device.present?
      device_max_time = member.max_screen_time(Time.now, self.device_id)
      device_used_time = member.used_screen_time(Time.now, self.device_id)
      if device_used_time >= device_max_time
        errors.add(:device, 'max screen time for today exceeded.')
      end
    end

    used_time = member.used_screen_time
    if used_time >= max_time
      errors.add(:member, 'max screen time for today exceeded.')
    end
  end

end
