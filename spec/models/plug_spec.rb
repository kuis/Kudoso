require 'rails_helper'

RSpec.describe Plug, type: :model do
  it 'has a valid factory' do
    plug = FactoryGirl.create(:plug)
    expect(plug.valid?).to be_truthy
    expect(plug.serial.length).to eq(32)
  end

  it 'has a secure key' do
    plug = FactoryGirl.create(:plug)
    expect(plug.secure_key.length).to eq(40)
  end

  it 'updates last_seen and ip when touched' do
    plug = FactoryGirl.create(:plug)
    last_seen = plug.last_seen
    last_ip = plug.last_known_ip
    plug.touch('127.0.0.1')
    expect(plug.last_seen).to_not eq(last_seen)
    expect(plug.last_known_ip).to_not eq(last_ip)
  end
end
