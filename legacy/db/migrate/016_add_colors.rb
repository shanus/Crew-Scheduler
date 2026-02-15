class AddColors < ActiveRecord::Migration
  def self.up
    add_column :users, :color, :string, :default => nil
    add_column :teams, :color, :string, :default => nil
    add_column :boats, :color, :string, :default => nil
  end

  def self.down
    remove_column :users, :color
    remove_column :teams, :color
    remove_column :boats, :color
  end
end
