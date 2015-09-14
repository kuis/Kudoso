require 'rails_helper'

RSpec.describe "apps/show", type: :view do
  before(:each) do
    @app = assign(:app, App.create!(
      :name => "Name",
      :bundle_identifier => "Bundle Identifier",
      :publisher => "Publisher",
      :url => "Url"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Bundle Identifier/)
    expect(rendered).to match(/Publisher/)
    expect(rendered).to match(/Url/)
  end
end
