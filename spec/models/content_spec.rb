require 'rails_helper'

RSpec.describe Content, :type => :model do
  it 'has a valid factory' do
    content = FactoryGirl.create(:content)
    expect(content.valid?).to be_truthy
  end
end
