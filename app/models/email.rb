class Email < ActiveRecord::Base
  belongs_to :contact
  validates_uniqueness_of :address
end
