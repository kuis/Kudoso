class Ticket < ActiveRecord::Base
  belongs_to :assigned_to, class: User, foreign_key: 'assigned_to_id'
  belongs_to :user
  belongs_to :contact
  belongs_to :ticket_type

  has_many :notes, dependent: :destroy

  accepts_nested_attributes_for :notes
end
