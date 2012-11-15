class CreateTips < ActiveRecord::Migration
  def change
    create_table :tips do |t|
      t.text :content
      t.string :path
      t.integer :creator_id
      t.integer :modifier_id

      t.timestamps
    end
  end
end
