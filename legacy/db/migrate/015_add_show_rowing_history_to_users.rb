class AddShowRowingHistoryToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :public_rowing_history, :boolean, :default => false
  end

  def self.down
    remove_column :users, :public_rowing_history
  end
end
