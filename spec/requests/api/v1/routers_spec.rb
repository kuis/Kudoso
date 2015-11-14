# spec/requests/api/v1/routers_spec.rb

require 'rails_helper'

describe 'Routers API', type: :request do
  before(:each) do
    @router = FactoryGirl.create(:router)
    @api_device =  FactoryGirl.create(:api_device)
  end

  pending 'successfully registers an unregistered router' do
    skip
  end

  pending 'returns an error when a router was previous registered' do
    skip
  end

  pending 'returns an error for an unknown router' do
    skip
  end

  pending 'successfully handles a router ping' do
    skip
  end


end