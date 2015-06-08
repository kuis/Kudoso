require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users/sign_up" do
    it 'retruns a form with the required fields' do
      get '/users/sign_up'
      expect(response.status).to eq(200)
    end
  end
end