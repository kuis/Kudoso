require "rails_helper"

RSpec.describe ContentDescriptorsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/content_descriptors").to route_to("content_descriptors#index")
    end

    it "routes to #new" do
      expect(:get => "/content_descriptors/new").to route_to("content_descriptors#new")
    end

    it "routes to #show" do
      expect(:get => "/content_descriptors/1").to route_to("content_descriptors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/content_descriptors/1/edit").to route_to("content_descriptors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/content_descriptors").to route_to("content_descriptors#create")
    end

    it "routes to #update" do
      expect(:put => "/content_descriptors/1").to route_to("content_descriptors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/content_descriptors/1").to route_to("content_descriptors#destroy", :id => "1")
    end

  end
end
