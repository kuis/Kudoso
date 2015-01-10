require "rails_helper"

RSpec.describe ActivityTypesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/activity_types").to route_to("activity_types#index")
    end

    it "routes to #new" do
      expect(:get => "/activity_types/new").to route_to("activity_types#new")
    end

    it "routes to #show" do
      expect(:get => "/activity_types/1").to route_to("activity_types#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/activity_types/1/edit").to route_to("activity_types#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/activity_types").to route_to("activity_types#create")
    end

    it "routes to #update" do
      expect(:put => "/activity_types/1").to route_to("activity_types#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/activity_types/1").to route_to("activity_types#destroy", :id => "1")
    end

  end
end
