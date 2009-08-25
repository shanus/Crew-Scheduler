class AddBoatConditions < ActiveRecord::Migration
  def self.up
    add_column :boats, :boat_weight_id, :integer, :default => '2' # mwt
    add_column :boats, :boat_usage_id, :integer, :default => '4' # recreational
  end

  def self.down
    remove_column :boats, :boat_weight_id
    remove_column :boats, :boat_usage_id
  end
end
