class Theme < ActiveRecord::Base
  has_many :members

  validates_presence_of :name, :json

  validate :check_json

  def as_json(options = {})
    self.json
  end

  private

  def check_json
    begin
      JSON.parse(self.json)
    rescue JSON::ParserError
      errors.add(:json, 'parse error, please check syntax')
    end
  end
end
