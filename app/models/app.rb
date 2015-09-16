class App < ActiveRecord::Base
  has_many :app_devices, depepent: :destroy
  has_many :app_members, depepent: :destroy

  has_many :devices, through: :app_devices
  has_many :members, through: :app_members

  has_attached_file :icon, styles: { large: "300x300#", medium: "200x200#", small: "100x100#", thumb: "60x60#" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :icon, content_type: /\Aimage\/.*\Z/

  validates_presence_of :uuid
  validates_uniqueness_of :uuid

  def as_json(options={})
    super({except: [ :icon_file_name, :icon_content_type, :icon_file_size, :icon_updated_at ], methods: :icon_urls}.merge(options))
  end

  def icon_urls
    urls = {}
    if icon.exists?
      urls[:large] = icon.url(:large)
      urls[:medium] = icon.url(:medium)
      urls[:small] = icon.url(:small)
    end
    return urls
  end
end
