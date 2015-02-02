require 'rails_helper'

RSpec.describe "ActivityTemplates", :type => :request do
  describe "GET /activity_templates" do
    it "works! (now write some real specs)" do
      skip('build valid requests')
      get activity_templates_path
      expect(response).to have_http_status(200)
    end
  end
end
