class Member < ActiveRecord::Base
  belongs_to :family
  has_one :user
  has_one :todo_schedule

  validates_presence_of :first_name, :username

  validates :username, uniqueness: { scope: :family_id }

  def full_name
    "#{first_name} #{last_name}"
  end

end
