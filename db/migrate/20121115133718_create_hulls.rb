class CreateHulls < ActiveRecord::Migration
  def change
    create_table :hulls do |t|
      t.string :name
      t.integer :category_id
      t.string :seats

      t.timestamps
    end
  end
end
