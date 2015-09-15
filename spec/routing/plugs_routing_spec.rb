require "rails_helper"

RSpec.describe PlugsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/plugs").to route_to("plugs#index")
    end

    it "routes to #new" do
      expect(:get => "/plugs/new").to route_to("plugs#new")
    end

    it "routes to #show" do
      expect(:get => "/plugs/1").to route_to("plugs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/plugs/1/edit").to route_to("plugs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/plugs").to route_to("plugs#create")
    end

    it "routes to #update" do
      expect(:put => "/plugs/1").to route_to("plugs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/plugs/1").to route_to("plugs#destroy", :id => "1")
    end

  end
end
