class Note < ActiveRecord::Base
  belongs_to :ticket
  belongs_to :note_type
  has_many :note_attachments, dependent: :destroy
end
