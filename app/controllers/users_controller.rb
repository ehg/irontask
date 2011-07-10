class UsersController < ApplicationController
  
  def sign_in
    if User.valid_details?(params[:username], params[:password])
      redirect_to :controller => :tasks, :action => :index 
    else
      flash[:notice] = "Wrong Username/Email and password combination."
    end
  end

end
