require 'rails_helper'

RSpec.describe "MyTasks", :type => :request do
  describe "GET /my_tasks" do
    it "works! (now write some real specs)" do
      skip('build valid requests')
      get my_tasks_path
      expect(response).to have_http_status(200)
    end
  end
end
