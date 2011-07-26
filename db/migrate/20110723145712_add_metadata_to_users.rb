class AddMetadataToUsers < ActiveRecord::Migration
  def change
    add_column :users, :metadata, :string
  end
end
