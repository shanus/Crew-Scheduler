class AddOptionsToCoachAndCox < ActiveRecord::Migration
  def self.up
    add_column :users, :will_cox, :boolean, :default => false
    add_column :users, :will_coach, :boolean, :default => false
  end

  def self.down
    remove_column :users, :will_cox
    remove_column :users, :will_coach
  end
end
