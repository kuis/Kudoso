class ActivityTemplate < ActiveRecord::Base
  include NotDeleteable

  has_many :activity_template_device_type, dependent: :destroy
  has_many :device_types, through: :activity_template_device_type
  has_many :activities, dependent: :nullify
  belongs_to :activity_type
  has_one :partner, through: :activity_type

  validates_presence_of :name, :time_block, :activity_type
  validates :time_block, numericality: { greater_than: 0 } # Note: time_block is in MINUTES

end
