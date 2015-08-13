require 'rails_helper'

RSpec.describe "router_models/new", type: :view do
  before(:each) do
    assign(:router_model, RouterModel.new(
      :name => "MyString",
      :num => "MyString"
    ))
  end

  it "renders new router_model form" do
    render

    assert_select "form[action=?][method=?]", router_models_path, "post" do

      assert_select "input#router_model_name[name=?]", "router_model[name]"

      assert_select "input#router_model_num[name=?]", "router_model[num]"
    end
  end
end
