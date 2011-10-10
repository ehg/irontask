class HomeController < ApplicationController
  def index
    if current_user 
      redirect_to tasks_url
    else
      redirect_to new_session_url 
    end
  end

end
