require 'rails_helper'

RSpec.describe ContentDescriptor, :type => :model do
  it 'has a valid factory' do
    content_desc = FactoryGirl.create(:content_descriptor)
    expect(content_desc.valid?).to be_truthy
  end
end
