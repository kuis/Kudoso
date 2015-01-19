class ActivityTemplate < ActiveRecord::Base
  has_and_belongs_to_many :device_types
  has_many :family_activities, dependent: :nullify
  belongs_to :activity_type

  validates_presence_of :name, :time_block
  validates :time_block, numericality: { greater_than: 0 }

end
