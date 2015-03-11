class Contact < ActiveRecord::Base
  has_one :member, dependent: :nullify
  has_many :emails, dependent: :destroy

  def full_name
    "#{self.first_name} #{self.last_name}"
  end
end
