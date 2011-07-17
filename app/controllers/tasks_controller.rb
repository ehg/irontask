class TasksController < ApplicationController
  def index
    case params[:done]
      when true 
        render :text => Task.done_tasks.to_json    
      when false
        render :text => Task.undone_tasks.to_json    
    end
  end

  def create
    task = Task.new :content => params[:content], :done => params[:done]
    if task.save
      render :text => "task saved"
    else
      render :status => 400, :text => task.errors.to_json
    end
  end

  def update
    if task = Task.where(:id => params[:id]).first
      task.update_attributes params
      if task.save
        render :text => "task updated"
      else
        render :status => 400, :text => task.errors.to_json
      end
    else
      render :status => 400, :text => "task not found"
    end
  end

  def destroy
    begin
      Task.destroy(params[:id])
      render :text => "task deleted"
    rescue
      render :status => 400, :text => $! 
    end
  end
end
