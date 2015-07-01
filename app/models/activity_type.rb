class ActivityType < ActiveRecord::Base
  has_many :activities, through: :activity_templates
  has_many :activity_templates
  belongs_to :partner

  serialize :metadata_fields, Hash

  validates_presence_of :name
  validates_uniqueness_of :name

end
