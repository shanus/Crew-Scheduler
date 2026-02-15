class AddUsersToTeams < ActiveRecord::Migration
  def self.up
    add_column :users, :team_id, :integer, :default => 1
    User.update_all "team_id = 1" 
  end

  def self.down
    remove_column :users, :team_id
  end
end
