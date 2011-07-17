class Task < ActiveRecord::Base
  validates_presence_of :content
  validates_inclusion_of :done, :in => [true, false]

  attr_accessible :content, :done

  def self.undone_tasks
    Task.where(:done => false)
  end

  def self.done_tasks
    Task.where(:done => true)
  end
end
