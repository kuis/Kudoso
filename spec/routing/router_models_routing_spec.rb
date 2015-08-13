require "rails_helper"

RSpec.describe RouterModelsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/router_models").to route_to("router_models#index")
    end

    it "routes to #new" do
      expect(:get => "/router_models/new").to route_to("router_models#new")
    end

    it "routes to #show" do
      expect(:get => "/router_models/1").to route_to("router_models#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/router_models/1/edit").to route_to("router_models#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/router_models").to route_to("router_models#create")
    end

    it "routes to #update" do
      expect(:put => "/router_models/1").to route_to("router_models#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/router_models/1").to route_to("router_models#destroy", :id => "1")
    end

  end
end
