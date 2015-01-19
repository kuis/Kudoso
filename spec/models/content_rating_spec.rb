require 'rails_helper'

RSpec.describe ContentRating, :type => :model do
  it 'has a valid factory' do
    rating = FactoryGirl.create(:content_rating)
    expect(rating.valid?).to be_truthy
  end
end
