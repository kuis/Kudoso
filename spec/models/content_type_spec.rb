require 'rails_helper'

RSpec.describe ContentType, :type => :model do
  it 'has a valid factory' do
    content_t = FactoryGirl.create(:content_type)
    expect(content_t.valid?).to be_truthy
  end
end
