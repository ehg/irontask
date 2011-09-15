class ChangeContentToTextInTasks < ActiveRecord::Migration
  def up
    change_column :tasks, :content, :text
  end

  def down
    change_column :tasks, :content, :string
  end
end
