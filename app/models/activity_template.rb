class ActivityTemplate < ActiveRecord::Base
  has_many :family_activities, dependent: :nullify
end
