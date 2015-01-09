class ActivityTemplate < ActiveRecord::Base
  has_many :activities, dependent: :nullify
end
