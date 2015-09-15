class Avatar < ActiveRecord::Base

  belongs_to :theme

  has_attached_file :image, :styles => { :large => "300x300#", :medium => "200x200#", :small => "100x100#", :thumb => "60x60#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_inclusion_of :gender, :in => %w( m f ), allow_blank: :true

  def as_json(options = {})
    super({methods: [ :image_urls], except: [:image_file_name, :image_content_type, :image_file_size, :image_updated_at], include: [ {theme: {except: [:created_at, :updated_at] } }] }.merge(options))
  end

  def image_urls
    urls = Hash.new
    if self.image.exists?
      urls[:large] = self.image.url(:large)
      urls[:medium] = self.image.url(:medium)
      urls[:small] = self.image.url(:small)
      urls[:thumb] = self.image.url(:thumb)
    end
    return urls
  end
end
