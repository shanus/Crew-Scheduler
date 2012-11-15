class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :coach
      t.string :coxswain
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :team_id
      t.integer :boat_id

      t.timestamps
    end
  end
end
