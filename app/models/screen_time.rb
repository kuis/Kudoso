class ScreenTime < ActiveRecord::Base
  belongs_to :member
  belongs_to :device

  validates_presence_of :member_id, :maxtime

  # maxtime is in seconds
  validates :maxtime, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 86400 } # 86400 = 24 Hours * 60 min * 60 sec


end
