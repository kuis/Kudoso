require "rails_helper"

RSpec.describe MyTodosController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/my_todos").to route_to("my_todos#index")
    end

    it "routes to #new" do
      expect(:get => "/my_todos/new").to route_to("my_todos#new")
    end

    it "routes to #show" do
      expect(:get => "/my_todos/1").to route_to("my_todos#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/my_todos/1/edit").to route_to("my_todos#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/my_todos").to route_to("my_todos#create")
    end

    it "routes to #update" do
      expect(:put => "/my_todos/1").to route_to("my_todos#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/my_todos/1").to route_to("my_todos#destroy", :id => "1")
    end

  end
end
