class Ticket < ActiveRecord::Base
  belongs_to :assigned_to, class: User, foreign_key: 'assigned_to_id'
  belongs_to :user
  belongs_to :contact
  belongs_to :ticket_type

  scope :open, -> (open) { open ? where(date_closed: nil) : where.not(date_closed: nil) }
  scope :assigned_to, -> (id) { id.nil? ? where(nil) : where(assigned_to_id: id)}

  validates_presence_of :ticket_type, :contact

  has_many :notes, dependent: :destroy

  accepts_nested_attributes_for :notes, :reject_if => :all_blank, :allow_destroy => true


  before_create { self.date_openned ||= Time.now }

  def default_statuses
    ["New", "In Progress", "Waiting on Customer", "Waiting on Partner", "Resolved", "Unresolved" ]
  end
end
