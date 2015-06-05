class User < ActiveRecord::Base

  belongs_to :family
  belongs_to :member

  has_many :tickets, dependent: :destroy
  has_many :assigned_tickets, class: Ticket, foreign_key: 'assigned_to_id', dependent: :nullify
  has_many :api_keys

  scope :admins, -> { where(admin: true) }
  scope :accounts, -> { where.not(admin: true) }

  attr_accessor :first_name, :last_name

  after_create :build_family


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable, :timeoutable, :omniauthable,
         :authentication_keys => [:email]


  validates_presence_of :first_name, :last_name, :email

  def set_admin!
    self.update_attribute(:admin, true)
  end

  def del_admin!
    self.update_attribute(:admin, false)
  end

  def full_name
    member.try(:full_name) || email
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
      self.member = self.family.members.create({username: self.email, parent: true })
      self.member.create_contact({first_name: self.first_name, last_name: self.last_name, contact_type_id: ContactType.find_or_create_by(name: 'Customer').id})
      self.member.contact.emails.create({address: self.email, is_primary: true})
      self.wizard_step = 1
      self.save
      self.member.save
    end
  end
end
