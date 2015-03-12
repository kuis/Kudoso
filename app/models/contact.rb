class Contact < ActiveRecord::Base
  has_one :member, dependent: :nullify
  has_many :emails, dependent: :destroy

  def primary_email
    "#{emails.primary.first.try(:address)}"
  end

  def full_name
    "#{self.first_name} #{self.last_name}"
  end

  def label
    "#{self.last_name}, #{self.first_name} <#{ self.primary_email }>"
  end
end
