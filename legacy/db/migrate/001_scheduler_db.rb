class SchedulerDb < ActiveRecord::Migration
  def self.up
    create_table :boats do |t|
      t.column :name, :string, :default => "", :null => false
      t.column :hull_type, :string, :limit => 10, :default => "4+", :null => false
    end
  end

  def self.down
    drop_table :boats
  end
end
