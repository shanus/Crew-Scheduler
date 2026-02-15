class AddRemindersToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :send_reminders, :boolean, :default => false
  end

  def self.down
    remove_column :users, :send_reminders
  end
end