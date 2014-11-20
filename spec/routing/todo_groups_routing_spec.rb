require "rails_helper"

RSpec.describe TodoGroupsController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/todo_groups").to route_to("todo_groups#index")
    end

    it "routes to #new" do
      expect(:get => "/todo_groups/new").to route_to("todo_groups#new")
    end

    it "routes to #show" do
      expect(:get => "/todo_groups/1").to route_to("todo_groups#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/todo_groups/1/edit").to route_to("todo_groups#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/todo_groups").to route_to("todo_groups#create")
    end

    it "routes to #update" do
      expect(:put => "/todo_groups/1").to route_to("todo_groups#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/todo_groups/1").to route_to("todo_groups#destroy", :id => "1")
    end

  end
end
