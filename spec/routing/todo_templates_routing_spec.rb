require "rails_helper"

RSpec.describe TodoTemplatesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/todo_templates").to route_to("todo_templates#index")
    end

    it "routes to #new" do
      expect(:get => "/todo_templates/new").to route_to("todo_templates#new")
    end

    it "routes to #show" do
      expect(:get => "/todo_templates/1").to route_to("todo_templates#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/todo_templates/1/edit").to route_to("todo_templates#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/todo_templates").to route_to("todo_templates#create")
    end

    it "routes to #update" do
      expect(:put => "/todo_templates/1").to route_to("todo_templates#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/todo_templates/1").to route_to("todo_templates#destroy", :id => "1")
    end

  end
end
