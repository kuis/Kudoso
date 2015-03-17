class ScreenTimeSchedule < ActiveRecord::Base

  belongs_to :family # if family set, schedule applies to all family members
  belongs_to :member # if member set, schedule applies to only this member

  serialize :restrictions, Hash

  after_initialize :init_restrictions

  validate :check_restrictions


  def occurring_at?(time = Time.now)
    secs = time.seconds_since_midnight.to_i
    self.restrictions["#{time.wday}"].each do |restriction|
      return true if restriction[0] <= secs && secs <= restriction[1]
    end
    false
  end

  private

  def init_restrictions
    self.restrictions ||= Hash.new
    (0..6).each do |dow|
      self.restrictions["#{dow}"] ||= Array.new
    end
  end

  def check_restrictions
    self.restrictions.each do |key, values|
      self.errors.add(:restrictions, "invalid day of week specified") unless (0..6).map(&:to_s).include?(key)
      self.errors.add(:restrictions, "restriction not valid") unless values.nil? || values.is_a?(Array)
      if values.is_a?(Array)

        values.each do |value|
          self.errors.add(:restrictions, "restriction time not valid") unless value.is_a?(Array) && value.length == 2
          self.errors.add(:restrictions, "restriction time for dow(#{key}) not valid, start time(#{value[0]}) must be >= 0, end time(#{value[1]}) must by > start time and  <= 86400") unless value[0].to_i >= 0  && value[1] > value[0] && value[1].to_i <= 86400
        end
      end
    end
  end


end
