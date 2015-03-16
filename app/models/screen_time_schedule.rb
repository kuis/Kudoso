class ScreenTimeSchedule < ActiveRecord::Base

  belongs_to :family # if family set, schedule applies to all family members
  belongs_to :member # if member set, schedule applies to only this member
  has_many :screen_time_schedule_rrules

  accepts_nested_attributes_for :screen_time_schedule_rrules, :reject_if => :all_blank, :allow_destroy => true

  validate :assignments
  validates :start_time, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 86400}, :presence => true
  validates :end_time, numericality: {greater_than_or_equal_to: 0, less_than_or_equal_to: 86400}, :presence => true
  validate :increasing_time

  def start_time
    Time.now.beginning_of_day + start_seconds
  end

  def end_time
    Time.now.beginning_of_day + end_seconds
  end

  def start_time=(stime)  # ex: start_time = '8:00am'
    parsed_time = Chronic.parse(stime)
    if parsed_time
      self.start_seconds = parsed_time.seconds_since_midnight
    end
  end

  def end_time=(etime)  # ex: end_time = '8:00am'
    parsed_time = Chronic.parse(etime)
    if parsed_time
      self.end_seconds = parsed_time.seconds_since_midnight
    end
  end

  def schedule
    sch = IceCube::Schedule.new
    sch.start_time = self.start_time
    sch.end_time = self.end_time
    self.screen_time_schedule_rrules.each do |rrule|
      sch.add_recurrence_rule(rrule.rule)
    end
    sch
  end

  private

  def assignments
    if family_id.present? && member_id.present?
      errors.add(:member_id, 'cannot be set when assigned to a family')
    end
    if family_id.blank? && member_id.blank
      errors.add(:base, 'must be assigned to a family or a member')
    end
  end

  def increasing_time
    if start_time >= end_time
      errors.add(:end_time, 'must be greater than start time')
    end
  end
end
