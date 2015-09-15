require 'rails_helper'



RSpec.describe AvatarsController, type: :controller do



  describe "GET #index" do
    it "assigns all avatars as @avatars" do
      avatar = FactoryGirl.create(:avatar)
      get :index, {}
      expect(assigns(:avatars)).to eq([avatar])
    end
  end

  describe "GET #show" do
    it "assigns the requested avatar as @avatar" do
      avatar = FactoryGirl.create(:avatar)
      get :show, {:id => avatar.to_param}
      expect(assigns(:avatar)).to eq(avatar)
    end
  end



end
