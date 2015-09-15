require 'rails_helper'

RSpec.describe "apps/edit", type: :view do
  before(:each) do
    @app = assign(:app, App.create!(
      :name => "MyString",
      :bundle_identifier => "MyString",
      :publisher => "MyString",
      :url => "MyString"
    ))
  end

  it "renders the edit app form" do
    render

    assert_select "form[action=?][method=?]", app_path(@app), "post" do

      assert_select "input#app_name[name=?]", "app[name]"

      assert_select "input#app_bundle_identifier[name=?]", "app[bundle_identifier]"

      assert_select "input#app_publisher[name=?]", "app[publisher]"

      assert_select "input#app_url[name=?]", "app[url]"
    end
  end
end
