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

  before_update :audit_changes
  before_create { self.date_openned ||= Time.now }

  def default_statuses
    ["New", "In Progress", "Waiting on Customer", "Waiting on Partner", "Resolved", "Unresolved" ]
  end

  private

  def audit_changes
    note = nil
    self.changes.each do |key, value|
      if key.present? && key != 'updated_at' && value.is_a?(Array) && value.length == 2
        note ||= self.notes.create(title: 'Ticket update audit notes', note_type_id: NoteType.find_by_name('Ticket Update').id )
        note.body ||= '<ul>'
        note.body += "<li>#{key} was changed from '#{value[0]}' to '#{value[1]}' </li>"
      end
    end
    unless note.nil?
      note.body ||= '</ul>'
      note.save
    end
  end
end
