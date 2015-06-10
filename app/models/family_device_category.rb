class FamilyDeviceCategory < ActiveRecord::Base
  belongs_to :family
  belongs_to :device_category

  validates_presence_of :family, :device_category
  validates :amount, numericality: { :greater_than_or_equal_to => 0 }, :presence => true
end
