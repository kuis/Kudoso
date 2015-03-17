require "rails_helper"

RSpec.describe ApiDevicesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/api_devices").to route_to("api_devices#index")
    end

    it "routes to #new" do
      expect(:get => "/api_devices/new").to route_to("api_devices#new")
    end

    it "routes to #show" do
      expect(:get => "/api_devices/1").to route_to("api_devices#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/api_devices/1/edit").to route_to("api_devices#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/api_devices").to route_to("api_devices#create")
    end

    it "routes to #update" do
      expect(:put => "/api_devices/1").to route_to("api_devices#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/api_devices/1").to route_to("api_devices#destroy", :id => "1")
    end

  end
end
