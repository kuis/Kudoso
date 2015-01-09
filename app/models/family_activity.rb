class FamilyActivity < ActiveRecord::Base
  belongs_to :activity_template
  has_many :activities
  has_many :members, through: :activities
end
