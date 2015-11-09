class DeviceType < ActiveRecord::Base
  has_many :activity_template_device_types, dependent: :destroy
  has_many :activity_templates, through: :activity_template_device_types
  has_many :devices, dependent: :restrict_with_error
  belongs_to :device_category

  has_attached_file :icon
  do_not_validate_attachment_file_type :icon

  validates_presence_of :name
  validates_uniqueness_of :name
  validates :version, :uniqueness => {:scope => :name}, allow_blank: true
end
