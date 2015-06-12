class User < ActiveRecord::Base

  belongs_to :family
  belongs_to :member

  has_many :tickets, dependent: :destroy
  has_many :assigned_tickets, class: Ticket, foreign_key: 'assigned_to_id', dependent: :nullify
  has_many :api_keys

  scope :admins, -> { where(admin: true) }
  scope :accounts, -> { where.not(admin: true) }

  after_create :build_family


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable,
         :authentication_keys => [:email]


  validates_presence_of :email, :last_name
  validates_uniqueness_of :email

  def set_admin!
    self.update_attribute(:admin, true)
  end

  def del_admin!
    self.update_attribute(:admin, false)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def get_api_key
    key = self.api_keys.last
    if key.nil? or key.expires_at < DateTime.now()
      key = self.api_keys.create
    else
      key.update_expiration!
    end
    key
  end

  private

  def build_family
    if !self.admin? && self.family_id.nil?
      self.create_family(name: "#{self.last_name} Family", primary_contact_id: self.id)
      self.wizard_step = 2
      self.member = self.family.members.create({username: self.email, parent: true, first_name: self.first_name, last_name: self.last_name, email: self.email })
      self.save
      self.member.save
    end
  end
end
