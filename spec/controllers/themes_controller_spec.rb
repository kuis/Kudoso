require 'rails_helper'

RSpec.describe ThemesController, type: :controller do

  describe "GET #index" do
    it "assigns all themes as @themes" do
      theme = FactoryGirl.create(:theme)
      get :index, {}
      expect(assigns(:themes)).to eq([theme])
    end
  end

end