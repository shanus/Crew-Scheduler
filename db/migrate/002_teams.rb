class Teams < ActiveRecord::Migration
  def self.up
    create_table :teams do |t|
      t.column :name, :string, :limit => 50, :default => "", :null => false
    end
    Team.create :name => "Pickup"
  end

  def self.down
    drop_table :teams
  end
end
