class ApiKey < ActiveRecord::Base
  before_create :generate_access_token

  belongs_to :member
  has_many :api_sessions

  def update_expiration!
    self.expires_at = DateTime.now + 1.hour
    self.save
  end

  private

  def generate_access_token
    begin
      self.access_token = SecureRandom.hex
    end while self.class.exists?(access_token: access_token)
    self.expires_at = DateTime.now + 1.hour
  end

end
