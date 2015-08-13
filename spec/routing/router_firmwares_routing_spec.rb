require "rails_helper"

RSpec.describe RouterFirmwaresController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/router_firmwares").to route_to("router_firmwares#index")
    end

    it "routes to #new" do
      expect(:get => "/router_firmwares/new").to route_to("router_firmwares#new")
    end

    it "routes to #show" do
      expect(:get => "/router_firmwares/1").to route_to("router_firmwares#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/router_firmwares/1/edit").to route_to("router_firmwares#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/router_firmwares").to route_to("router_firmwares#create")
    end

    it "routes to #update" do
      expect(:put => "/router_firmwares/1").to route_to("router_firmwares#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/router_firmwares/1").to route_to("router_firmwares#destroy", :id => "1")
    end

  end
end
