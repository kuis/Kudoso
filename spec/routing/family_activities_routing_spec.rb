require "rails_helper"

RSpec.describe FamilyActivitiesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/family_activities").to route_to("family_activities#index")
    end

    it "routes to #new" do
      expect(:get => "/family_activities/new").to route_to("family_activities#new")
    end

    it "routes to #show" do
      expect(:get => "/family_activities/1").to route_to("family_activities#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/family_activities/1/edit").to route_to("family_activities#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/family_activities").to route_to("family_activities#create")
    end

    it "routes to #update" do
      expect(:put => "/family_activities/1").to route_to("family_activities#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/family_activities/1").to route_to("family_activities#destroy", :id => "1")
    end

  end
end
