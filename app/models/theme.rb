class Theme < ActiveRecord::Base
  has_many :members

  validates_presence_of :name, :primary_color, :secondary_color, :primary_bg_color, :secondary_bg_color

  validates_format_of :primary_bg_color, :secondary_bg_color, :primary_color, :secondary_color, :with => /\A#(([0-9a-fA-F]{2}){3}|([0-9a-fA-F]){3})\z/i

  def as_json(options = {})
    super({except: [:created_at, :updated_at] }.merge(options))
  end
end
