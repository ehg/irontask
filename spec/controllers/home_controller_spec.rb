require 'spec_helper'

describe HomeController do

  describe "GET 'index'" do

    def mock_user(stubs={})
      @mock_user ||= mock_model(User, stubs).as_null_object
    end

    it "should redirect to sign in in user isn't signed in" do
      request.env['warden'] = mock(Warden, :user => nil)
      get 'index'
      response.should redirect_to(:controller => 'user_sessions', :action => 'new')
    end

    it "should redirect to the tasks page if the user's signed in" do
      request.env['warden'] = mock(Warden, :user => mock_user)
      get 'index'
      response.should redirect_to(:controller => 'tasks', :action => 'index')
    end
  end

end
