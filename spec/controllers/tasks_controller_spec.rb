require 'spec_helper'

describe TasksController do
  before :each do
    mock_user = User.make!
    5.times do |i|
      task = Task.make(:user_id => mock_user.id, :content => "Task #{i}", :done => i % 2 == 0 ) 
      mock_user.tasks << task
      mock_user.save!
    end
    request.env['warden'] = mock(Warden, :authenticate! => mock_user,
                                         :authenticate  => mock_user,
                                         :user          => mock_user)
  end

  describe "GET tasks" do
    it "should return a list of done tasks" do
      get :index, :format => :json
      response.should be_success
      response.body.should =~ /Task 2/m
    end

  end

  describe "POST tasks" do
    it "saves a new task" do
      post :create, {:content => "new task", :done => false}, :format => :json
      response.should be_success
    end

    it "returns an error if invalid task parameters are saved" do
      post :create, :format => :json
      response.should_not be_success
    end
  end

  describe "PUT tasks/id" do
    it "updates a task if it exists" do
      put :update, {:id => 1}, :format => :json
      response.should be_success
    end

    it "returns an error if a task does not exist" do
      put :update, {:id => 100}, :format => :json 
      response.should_not be_success
    end
  end

  describe "DELETE tasks/id" do
    it "deletes a task if it exists" do
      put :destroy, {:id => 1}, :format => :json
      response.should be_success
    end

    it "returns an error if a task does not exist" do
      put :destroy, {:id => 100}, :format => :json
      response.should_not be_success
    end
  end
end
