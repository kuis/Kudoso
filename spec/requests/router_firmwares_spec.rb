require 'rails_helper'

RSpec.describe "RouterFirmwares", type: :request do
  describe "GET /router_firmwares" do
    it "works! (now write some real specs)" do
      get router_firmwares_path
      expect(response).to have_http_status(200)
    end
  end
end
