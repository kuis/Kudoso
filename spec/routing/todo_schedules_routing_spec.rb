require "rails_helper"

RSpec.describe TodoSchedulesController, :type => :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/todo_schedules").to route_to("todo_schedules#index")
    end

    it "routes to #new" do
      expect(:get => "/todo_schedules/new").to route_to("todo_schedules#new")
    end

    it "routes to #show" do
      expect(:get => "/todo_schedules/1").to route_to("todo_schedules#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/todo_schedules/1/edit").to route_to("todo_schedules#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/todo_schedules").to route_to("todo_schedules#create")
    end

    it "routes to #update" do
      expect(:put => "/todo_schedules/1").to route_to("todo_schedules#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/todo_schedules/1").to route_to("todo_schedules#destroy", :id => "1")
    end

  end
end
