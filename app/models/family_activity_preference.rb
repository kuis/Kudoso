class FamilyActivityPreference < ActiveRecord::Base
  belongs_to :activity_template
  belongs_to :family
end
