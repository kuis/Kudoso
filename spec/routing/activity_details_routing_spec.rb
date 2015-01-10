require "rails_helper"

RSpec.describe ActivityDetailsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/activity_details").to route_to("activity_details#index")
    end

    it "routes to #new" do
      expect(:get => "/activity_details/new").to route_to("activity_details#new")
    end

    it "routes to #show" do
      expect(:get => "/activity_details/1").to route_to("activity_details#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/activity_details/1/edit").to route_to("activity_details#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/activity_details").to route_to("activity_details#create")
    end

    it "routes to #update" do
      expect(:put => "/activity_details/1").to route_to("activity_details#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/activity_details/1").to route_to("activity_details#destroy", :id => "1")
    end

  end
end
