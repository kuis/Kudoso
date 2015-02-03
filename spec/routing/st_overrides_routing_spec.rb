require "rails_helper"

RSpec.describe StOverridesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/st_overrides").to route_to("st_overrides#index")
    end

    it "routes to #new" do
      expect(:get => "/st_overrides/new").to route_to("st_overrides#new")
    end

    it "routes to #show" do
      expect(:get => "/st_overrides/1").to route_to("st_overrides#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/st_overrides/1/edit").to route_to("st_overrides#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/st_overrides").to route_to("st_overrides#create")
    end

    it "routes to #update" do
      expect(:put => "/st_overrides/1").to route_to("st_overrides#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/st_overrides/1").to route_to("st_overrides#destroy", :id => "1")
    end

  end
end
