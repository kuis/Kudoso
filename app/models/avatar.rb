class Avatar < ActiveRecord::Base
  has_attached_file :image, :styles => { :large => "300x300#", :medium => "200x200#", :small => "100x100#", :thumb => "60x60#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/

  validates_inclusion_of :gender, :in => %w( m f ), allow_blank: :true
end
