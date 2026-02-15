class CreateBoatWeights < ActiveRecord::Migration
  def self.up
    create_table :boat_weights do |t|
      t.column :name, :string, :limit => 20, :default => "mwt"
      t.timestamps
    end
    BoatWeight.create( :name => "lwt")
    BoatWeight.create( :name => "mwt")
    BoatWeight.create( :name => "hwt")
  end

  def self.down
    drop_table :boat_weights
  end
end
