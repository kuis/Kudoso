class ActivityType < ActiveRecord::Base
  has_many :activities
  has_many :activity_templates

  serialize :metadata_fields, Hash

  validates_presence_of :name
  validates_uniqueness_of :name

end
