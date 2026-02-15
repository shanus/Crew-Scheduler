class CreateBoatUsages < ActiveRecord::Migration
  def self.up
    create_table :boat_usages do |t|
      t.column :name, :string,:limit => 20, :default => "recreation"
      t.timestamps
    end
    BoatUsage.create(:name => "Any")
    BoatUsage.create(:name => "Novice")
    BoatUsage.create(:name => "Beginner")
    BoatUsage.create(:name => "Recreational")
    BoatUsage.create(:name => "Competitive")
    BoatUsage.create(:name => "Elite/Racing")
  end

  def self.down
    drop_table :boat_usages
  end
end
