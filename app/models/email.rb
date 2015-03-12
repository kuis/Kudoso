class Email < ActiveRecord::Base
  belongs_to :contact
  scope :primary, -> { where(is_primary: true).limit(1) }


  validates_uniqueness_of :address
  validates_uniqueness_of :is_primary, scope: :contact_id, :if => :is_primary   # only one is allowed to be primary



end
