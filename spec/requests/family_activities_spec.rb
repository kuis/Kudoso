require 'rails_helper'

RSpec.describe "FamilyActivities", :type => :request do
  describe "GET /family_activities" do
    it "works! (now write some real specs)" do
      get family_activities_path
      expect(response).to have_http_status(200)
    end
  end
end
