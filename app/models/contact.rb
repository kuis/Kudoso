class Contact < ActiveRecord::Base
  has_one :member, dependent: :nullify
  has_many :emails, dependent: :destroy
  belongs_to :contact_type
  belongs_to :address_type
  belongs_to :phone_type
  has_one :fc_questionaire

  accepts_nested_attributes_for :emails, :reject_if => :all_blank, :allow_destroy => true
  accepts_nested_attributes_for :fc_questionaire, :reject_if => :all_blank, :allow_destroy => true

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
