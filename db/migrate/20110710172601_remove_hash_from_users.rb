class RemoveHashFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :hash
  end

  def down
    add_column :users, :hash, :string
  end
end
