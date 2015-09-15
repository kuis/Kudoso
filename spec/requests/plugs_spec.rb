require 'rails_helper'

RSpec.describe "Plugs", type: :request do
  describe "GET /plugs" do
    it "works! (now write some real specs)" do
      get plugs_path
      expect(response).to have_http_status(200)
    end
  end
end
