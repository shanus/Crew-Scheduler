class CreateBoats < ActiveRecord::Migration
  def change
    create_table :boats do |t|
      t.string :name
      t.integer :hull_id
      t.integer :usage_id
      t.integer :weight_id
      t.string :color

      t.timestamps
    end
  end
end
