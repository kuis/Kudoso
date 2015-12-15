class FcQuestionaire < ActiveRecord::Base
  belongs_to :contact

  validates_presence_of :contact
end
