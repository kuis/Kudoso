require 'rails_helper'

RSpec.describe "apps/new", type: :view do
  before(:each) do
    assign(:app, App.new(
      :name => "MyString",
      :bundle_identifier => "MyString",
      :publisher => "MyString",
      :url => "MyString"
    ))
  end

  it "renders new app form" do
    render

    assert_select "form[action=?][method=?]", apps_path, "post" do

      assert_select "input#app_name[name=?]", "app[name]"

      assert_select "input#app_bundle_identifier[name=?]", "app[bundle_identifier]"

      assert_select "input#app_publisher[name=?]", "app[publisher]"

      assert_select "input#app_url[name=?]", "app[url]"
    end
  end
end
