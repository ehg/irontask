require 'spec_helper'

describe TasksController do
  before :each do
    5.times { |i| Task.make( :content => "Task #{i}", :done => i % 2 == 0 ).save! }
  end

  describe "GET tasks" do
    it "should return a list of done tasks" do
      get :index, {:done => true}
      response.should be_success
      response.body.should =~ /Task 2/m
    end

    it "should return a list of undone tasks" do
      get :index, {:done => false}
      response.should be_success
      response.body.should =~ /Task 3/m
    end
  end

  describe "POST tasks" do
    it "saves a new task" do
      post :create, {:content => "new task", :done => false}
      response.should be_success
    end

    it "returns an error if invalid task parameters are saved" do
      post :create
      response.should_not be_success
    end
  end

  describe "PUT tasks/id" do
    it "updates a task if it exists" do
      put :update, {:id => 1}
      response.should be_success
    end

    it "returns an error if a task does not exist" do
      put :update, {:id => 100} 
      response.should_not be_success
    end
  end

  describe "DELETE tasks/id" do
    it "deletes a task if it exists" do
      put :destroy, {:id => 1}
      response.should be_success
    end

    it "returns an error if a task does not exist" do
      put :destroy, {:id => 100}
      response.should_not be_success
    end
  end
end
