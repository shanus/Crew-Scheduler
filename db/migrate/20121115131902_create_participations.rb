class CreateParticipations < ActiveRecord::Migration
  def change
    create_table :participations do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :position

      t.timestamps
    end
  end
end
