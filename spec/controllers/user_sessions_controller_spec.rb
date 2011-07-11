require 'spec_helper'

describe UserSessionsController do
  describe "# GET new" do
    it "renders the sign in template" do
      get :new
      response.should render_template(:new)
    end
  end
end
