class FamilyActivity < ActiveRecord::Base
  belongs_to :family
  has_and_belongs_to_many :device_types
  belongs_to :activity_template
  has_many :activities, dependent: :restrict_with_error
  has_many :members, through: :activities

  serialize :device_chains, Array

  validates_presence_of :family_id, :family, :name, :time_block

  validates :time_block, numericality: { greater_than: 0 }

  def available_devices
    family.devices.where(:device_type_id => self.activity_template.device_types.map(&:id))
  end

end
