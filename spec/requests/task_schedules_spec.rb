require 'rails_helper'

RSpec.describe "TaskSchedules", :type => :request do
  describe "GET /task_schedules" do
    it "works! (now write some real specs)" do
      skip('build valid requests')
      get task_schedules_path
      expect(response).to have_http_status(200)
    end
  end
end
