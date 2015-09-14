class App < ActiveRecord::Base
  has_many :app_devices
  has_many :app_members

  has_many :devices, through: :app_devices
  has_many :members, through: :app_members

  has_attached_file :icon, styles: { large: "300x300#", medium: "200x200#", small: "100x100#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/

  validates_presence_of :uuid
  validates_uniqueness_of :uuid
end
