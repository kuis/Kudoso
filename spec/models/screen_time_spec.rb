require 'rails_helper'

RSpec.describe ScreenTime, :type => :model do
  it 'has a valid factory' do
    screentime = FactoryGirl.create(:screen_time)
    expect(screentime.valid?).to be_truthy
  end

  it 'should format time as a countdown' do
    screentime = FactoryGirl.create( :screen_time, maxtime: (60*60+60*33+46) )
    expect(screentime.to_s).to eq('1:33:46')

    # and have leading zeros
    screentime.maxtime =     (60*60+60*3+6)
    expect(screentime.to_s).to eq('1:03:06')
  end
end
