require 'spec_helper'

describe UsersController do
  describe "POST sign_in" do
    it "signs a user in" do
      username = 'test'
      password = 'testing'

      User.should_receive(:valid_details?).with( username, password)
      post :sign_in, { "username" => username, "password" => password }
    end

    it "redirects to the tasks page on successful sign in" do
      User.make!
      post :sign_in, { "username" => "test", "password" => "testing" }
      response.should redirect_to(:controller => :tasks)
    end
    
    it "presents an error if the username/password were wrong" do
      User.make!
      post :sign_in, { "username" => "wrong", "password" => "wrongpassword" }
      flash[:notice].should eq("Wrong Username/Email and password combination.")
    end
  end
end

