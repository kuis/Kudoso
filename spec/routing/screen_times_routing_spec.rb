require "rails_helper"

RSpec.describe ScreenTimesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/screen_times").to route_to("screen_times#index")
    end

    it "routes to #new" do
      expect(:get => "/screen_times/new").to route_to("screen_times#new")
    end

    it "routes to #show" do
      expect(:get => "/screen_times/1").to route_to("screen_times#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/screen_times/1/edit").to route_to("screen_times#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/screen_times").to route_to("screen_times#create")
    end

    it "routes to #update" do
      expect(:put => "/screen_times/1").to route_to("screen_times#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/screen_times/1").to route_to("screen_times#destroy", :id => "1")
    end

  end
end
