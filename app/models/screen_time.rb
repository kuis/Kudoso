class ScreenTime < ActiveRecord::Base
  belongs_to :member

  validates_presence_of :member_id, :max_time, :default_time

  # maxtime is in seconds
  validates :max_time, :default_time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 86400 } # 86400 = 24 Hours * 60 min * 60 sec
  validates :dow, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 6, only_integer: true }, allow_blank: true


  before_save :check_time
  before_save :check_restrictions

  after_initialize do
    self.restrictions ||= { devices: {}, activities: {} }
  end

  serialize :restrictions, Hash
  private

  def check_time
    self.errors.add(:max_time, 'must be greater than or equal to default time.') if self.max_time < self.default_time
  end

  def check_restrictions
    if self.restrictions.nil? || self.restrictions == {}
      self.restrictions = { devices: {}, activities: {} }
    end
  end
end
