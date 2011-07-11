class UserSessionsController < ApplicationController
  
  def new
  end
  
  def create
      authenticate!

      if logged_in?
        flash[:notice] = "Login successful!"
        redirect_to :controller => :tasks, :action => :index 
      end
    end

    def destroy
      logout

      flash[:notice] = "You have signed out."
      redirect_to new_session_path
    end

    def unauthenticated
      flash[:notice] = "Wrong Username/Email and password combination."

      redirect_to new_session_path
      return false
    end
end
