class CreateSeatingPositions < ActiveRecord::Migration
  def self.up
    create_table :seating_positions do |t|
      t.column :event_id, :integer
      t.column :user_id, :integer
      t.column :position, :integer
    end
    drop_table :events_users
  end

  def self.down
    drop_table :seating_positions
  end
end
