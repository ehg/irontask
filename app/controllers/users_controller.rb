class UsersController < ApplicationController

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save      
      render :status => 200, :json => @user
    else
      render :status => 400, :json => @user.errors 
    end
  end
  
  def show
    user = User.where(:username => params[:id]).first
    
    if user
      render :status => 200, :json => { :metadata => user.metadata }
    else
      render :status => 400, :json => { :error => 'unknown user' }
    end
  end

  def update
    user = User.where(:username => params[:id]).first
     if user
       user.metadata = params[:metadata]
       user.save!
       render :status => 200, :json => { :success => 'ok' }
     else
      render :status => 400, :json => { :error => 'unknown user' }
     end
  end

  def username_available
    if params[:username].length == 0 or User.where(:username => params[:username]).first
      render :status => 400, :json => { :error => 'username taken' }
    else
      render :status => 200, :json => { :success => 'ok'}
    end
  end
end
