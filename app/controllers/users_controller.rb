class UsersController < ApplicationController
  
  def sign_in
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
      redirect_to sign_in_url
    end

    def unauthenticated
      flash[:notice] = "Wrong Username/Email and password combination."

      redirect_to :controller => :users, :action => :sign_in 
      return false
    end

end
