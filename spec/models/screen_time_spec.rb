require 'rails_helper'

RSpec.describe ScreenTime, :type => :model do
  it 'has a valid factory' do
    screentime = FactoryGirl.create(:screen_time)
    expect(screentime.valid?).to be_truthy
  end

end
