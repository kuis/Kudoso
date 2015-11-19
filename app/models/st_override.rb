class StOverride < ActiveRecord::Base
  belongs_to :member
  belongs_to :created_by, class_name: Member, foreign_key: 'created_by_id'

  scope :today, -> { where(date: Date.today.beginning_of_day..Date.today.end_of_day) }

  validates_presence_of :member_id, :date, :time
  validates :time, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 86400 }

  after_create :extend_activities

  private

  def extend_activities
    if self.member.current_activity.try(:allowed_time)
      self.member.current_activity.allowed_time += self.time
      self.member.current_activity.save
    end
  end
end
