class AddCoxAndCoach < ActiveRecord::Migration
  def self.up
    add_column :teams, :require_cox, :boolean, :default => false
    add_column :teams, :require_coach, :boolean, :default =>false
    add_column :events, :coxswain, :string, :default => nil
    add_column :events, :coach, :string, :default =>nil
  end

  def self.down
    remove_column :teams, :require_cox
    remove_column :teams, :require_coach
    remove_column :events, :coxswain
    remove_column :events, :coach
  end
end
