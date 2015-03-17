require 'rails_helper'

RSpec.describe "ApiDevices", :type => :request do
  describe "GET /api_devices" do
    it "works! (now write some real specs)" do
      get api_devices_path
      expect(response).to have_http_status(200)
    end
  end
end
