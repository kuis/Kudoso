require 'rails_helper'

RSpec.describe "Users", :type => :request do
  describe "GET /users/sign_in" do
    it 'returns a form with the required fields' do
      get '/users/sign_in'
      expect(response.status).to eq(200)
    end
  end
end