require 'rails_helper'

RSpec.describe "ContentDescriptors", :type => :request do
  describe "GET /content_descriptors" do
    it "works! (now write some real specs)" do
      get content_descriptors_path
      expect(response).to have_http_status(200)
    end
  end
end
