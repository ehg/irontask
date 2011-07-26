class TasksController < ApplicationController
  before_filter :authenticate
  respond_to :html, :json


  def authenticate
    warden.authenticate!
  end

  def index
    case params[:done]
      when "1"
        respond_with Task.done_tasks(user).map { |t|   JSON(t.content) }
      else 
        respond_with Task.undone_tasks(user).map { |t|   { :id => t.id, 
                                                     :content => t.content,
                                                     :done => t.done 
                                                    } 
                                           }
    end
  end

  def create
    task = Task.new :content => params[:content], :done => params[:done] 
    user.tasks << task
    if task.save
      render :text => { :id => task.id }.to_json 
    else
      render :status => 400, :text => task.errors.to_json
    end
  end

  def update
    if task = Task.where(:id => params[:id], :user_id => user.id).first
      task.update_attributes params
      if task.save
        render :text => { :id => task.id }.to_json 
      else
        render :status => 400, :text => task.errors.to_json
      end
    else
      render :status => 400, :text => "task not found"
    end
  end

  def destroy
    begin
      user.tasks.destroy(params[:id])
      render :text => nil 
    rescue
      render :status => 400, :text => $! 
    end
  end
end
