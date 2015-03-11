require 'rails_helper'

RSpec.describe "notes/index", :type => :view do
  before(:each) do
    assign(:notes, [
      Note.create!(
        :ticket_id => 1,
        :note_type_id => 2,
        :title => "Title",
        :body => "MyText"
      ),
      Note.create!(
        :ticket_id => 1,
        :note_type_id => 2,
        :title => "Title",
        :body => "MyText"
      )
    ])
  end

  it "renders a list of notes" do
    render
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
  end
end
