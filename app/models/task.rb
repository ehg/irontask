class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :content
  validates_inclusion_of :done, :in => [true, false]

  attr_accessible :content, :done

  def self.undone_tasks(user)
    Task.where(:done => false, :user_id => user.id)
  end

  def self.done_tasks(user)
    Task.where(:done => true, :user_id => user.id)
  end
end
