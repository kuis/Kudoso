require 'rails_helper'

RSpec.describe "router_models/edit", type: :view do
  before(:each) do
    @router_model = assign(:router_model, RouterModel.create!(
      :name => "MyString",
      :num => "MyString"
    ))
  end

  it "renders the edit router_model form" do
    render

    assert_select "form[action=?][method=?]", router_model_path(@router_model), "post" do

      assert_select "input#router_model_name[name=?]", "router_model[name]"

      assert_select "input#router_model_num[name=?]", "router_model[num]"
    end
  end
end
