require 'rails_helper'

RSpec.describe FamilyActivity, :type => :model do
  it 'has a valid factory' do
    fam_act = FactoryGirl.create(:family_activity)
    expect(fam_act.valid?).to be_truthy
  end
end
