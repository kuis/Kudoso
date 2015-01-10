require "rails_helper"

RSpec.describe ContentRatingsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/content_ratings").to route_to("content_ratings#index")
    end

    it "routes to #new" do
      expect(:get => "/content_ratings/new").to route_to("content_ratings#new")
    end

    it "routes to #show" do
      expect(:get => "/content_ratings/1").to route_to("content_ratings#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/content_ratings/1/edit").to route_to("content_ratings#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/content_ratings").to route_to("content_ratings#create")
    end

    it "routes to #update" do
      expect(:put => "/content_ratings/1").to route_to("content_ratings#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/content_ratings/1").to route_to("content_ratings#destroy", :id => "1")
    end

  end
end
