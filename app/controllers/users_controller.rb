class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
      @user = User.new(params[:user])
      if @user.save      
        render :status => 200, :text => "User created"
      else
        render :status => 400, :text => @user.errors.to_json 
      end
    end
  
end
