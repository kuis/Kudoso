require 'rails_helper'

RSpec.describe "ContentRatings", :type => :request do
  describe "GET /content_ratings" do
    it "works! (now write some real specs)" do
      skip('build valid requests')
      get content_ratings_path
      expect(response).to have_http_status(200)
    end
  end
end
