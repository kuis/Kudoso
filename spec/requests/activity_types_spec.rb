require 'rails_helper'

RSpec.describe "ActivityTypes", :type => :request do
  describe "GET /activity_types" do
    it "works! (now write some real specs)" do
      get activity_types_path
      expect(response).to have_http_status(200)
    end
  end
end
