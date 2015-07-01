class Partner < ActiveRecord::Base
  has_many :activity_types
  has_many :activity_templates, through: :activity_types

  validates_uniqueness_of :name

  before_create :generate_api_key


  private

  def generate_api_key
    begin
      self.api_key = SecureRandom.hex
    end while self.class.exists?(api_key: api_key)
  end
end
