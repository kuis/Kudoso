class DeviceType < ActiveRecord::Base
  has_and_belongs_to_many :family_activities
  has_and_belongs_to_many :activity_templates
  has_many :devices, dependent: :restrict_with_error

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :version, :uniqueness => {:scope => :name}, allow_blank: true
end
