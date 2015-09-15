require 'rails_helper'

RSpec.describe "avatars/show", type: :view do
  before(:each) do
    @avatar = assign(:avatar, Avatar.create!(
      :name => "Name",
      :gender => "Gender",
      :theme_id => 1
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Gender/)
    expect(rendered).to match(/1/)
  end
end
