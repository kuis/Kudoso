require 'rails_helper'

RSpec.describe "ScreenTimes", :type => :request do
  describe "GET /screen_times" do
    it "works! (now write some real specs)" do
      skip('build valid requests')
      get screen_times_path
      expect(response).to have_http_status(200)
    end
  end
end
