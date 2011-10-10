class Task < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :content
  validates_inclusion_of :done, :in => [true, false]

  attr_accessible :content, :done

  def self.tasks(user)
    Task.where(:user_id => user.id)
  end
end
