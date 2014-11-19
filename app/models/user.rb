class User < ActiveRecord::Base
  belongs_to :household

  before_create :build_household


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable

  def set_admin!
    self.update_attribute(:admin, true)
  end

  def del_admin!
    self.update_attribute(:admin, false)
  end

  private

  def build_household
    if !self.admin? && self.parent? && self.household_id.nil?
      self.household = Household.create(name: "#{self.last_name} Household")
    end
  end
end
