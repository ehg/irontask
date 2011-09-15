class ChangeMetadataToTextInUsers < ActiveRecord::Migration
  def up
    change_column :users, :metadata, :text
  end

  def down
    change_column :users, :metadata, :string
  end
end
