class ScreenTime < ActiveRecord::Base
  belongs_to :member
  belongs_to :device

  validates_presence_of :member_id, :maxtime

  # maxtime is in seconds
  validates :maxtime, numericality: { greater_than: 0, less_than: 86400 } # 86400 = 24 Hours * 60 min * 60 sec

  def to_s
    sec = maxtime % 60
    min = (maxtime/60).floor
    hours = (min/60).floor
    if hours > 0
      min = min - (hours * 60)
      "#{hours}:#{sprintf('%02d', min)}:#{sprintf('%02d', sec)}"
    else
      "#{min}:#{sprintf('%02d', sec)}"
    end
  end
end
