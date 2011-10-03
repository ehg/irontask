require 'spec_helper'

describe UsersController do
  describe "POST username_available" do
    it "should be successful if a username is available" do
      post :username_available, {:username => 'test'}
      response.should be_success
    end

    it "should error if a username isn't available" do
      User.make!
      post :username_available, {:username => 'test'}
      response.should_not be_success
    end
  end
end

