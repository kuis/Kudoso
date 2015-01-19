class User < ActiveRecord::Base
  belongs_to :family
  belongs_to :member

  after_create :build_family


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable


  validates_presence_of :first_name, :last_name, :email

  def set_admin!
    self.update_attribute(:admin, true)
  end

  def del_admin!
    self.update_attribute(:admin, false)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  private

  def build_family
    if !self.admin? && self.family_id.nil?
      self.family = Family.create(name: "#{self.last_name} Family", primary_contact_id: self.id)
      self.member = self.family.members.build({first_name: self.first_name, last_name: self.last_name, username: self.email, parent: true })
      self.save!
    end
  end
end
