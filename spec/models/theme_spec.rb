require 'rails_helper'

RSpec.describe Theme, type: :model do
  it 'has a valid factory' do
    theme = FactoryGirl.create(:theme)
    expect(theme.valid?).to be_truthy
  end

  it 'accepts valid JSON' do
    theme = Theme.create({name: 'test theme', json: '{ "key" : "value" }' })
    expect(theme.valid?).to be_truthy
  end

  it 'does not accept ivalid JSON' do
    theme = Theme.create({name: 'test theme', json:'key : "value"'})
    expect(theme.valid?).to be_falsey
  end
end
