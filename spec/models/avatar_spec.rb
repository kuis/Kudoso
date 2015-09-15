require 'rails_helper'

RSpec.describe Avatar, type: :model do
  before(:each) do
    @avatar = FactoryGirl.create(:avatar)
  end

  it 'has a valid factory' do
    expect(@avatar.valid?).to be_truthy
  end

end
