class Activity < ActiveRecord::Base
  belongs_to :member                            # Family member who PERFORMED the activity, may be nil
  belongs_to :created_by, class_name: 'Member'  # Family member who CREATED the activity, required, allows tracking of anonymous access
  belongs_to :family_activity
  belongs_to :device
  belongs_to :family, through: :created_by
  belongs_to :activity_type
  has_many :details, class_name: 'ActivityDetail'

  validates_presence_of :created_by, :family_activity_id

  def anonymous?
    member.blank?
  end

end
