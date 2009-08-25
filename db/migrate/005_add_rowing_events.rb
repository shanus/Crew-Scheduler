class AddRowingEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.column :event_on, :date
      t.column :start_time, :time
      t.column :end_time, :time
      t.column :team_id, :integer
      t.column :boat_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
    create_table :events_users, :id => false do |t|
      t.column :event_id, :integer
      t.column :user_id, :integer
    end
  end

  def self.down
    drop_table :events
    drop_table :events_users
  end
end
