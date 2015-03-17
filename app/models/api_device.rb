class ApiDevice < ActiveRecord::Base
  before_create :generate_device_token


  private
  def generate_device_token
    begin
      self.device_token = SecureRandom.hex
    end while self.class.exists?(device_token: device_token)
  end
end
