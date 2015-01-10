require 'rails_helper'

RSpec.describe "ActivityDetails", :type => :request do
  describe "GET /activity_details" do
    it "works! (now write some real specs)" do
      get activity_details_path
      expect(response).to have_http_status(200)
    end
  end
end
