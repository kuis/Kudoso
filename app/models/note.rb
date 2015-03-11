class Note < ActiveRecord::Base
  belongs_to :ticket
  has_many :note_attachments, dependent: :destroy
end
