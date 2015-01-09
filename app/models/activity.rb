class Activity < ActiveRecord::Base
  belongs_to :member
  belongs_to :family_activity

  validates_presence_of :date, :duration, :member_id, :family_activity_id
end
