require 'rails_helper'

RSpec.describe "StOverrides", :type => :request do
  describe "GET /st_overrides" do
    it "works! (now write some real specs)" do
      get st_overrides_path
      expect(response).to have_http_status(200)
    end
  end
end
