class NoteAttachment < ActiveRecord::Base
  belongs_to :note

  validates_presence_of :note
end
