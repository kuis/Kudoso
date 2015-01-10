class ActivityType < ActiveRecord::Base
  has_many :activities
  has_many :activity_templates

  serialize :metadata_fields, Hash

end
