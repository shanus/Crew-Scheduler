class CreateBulletins < ActiveRecord::Migration
  def change
    create_table :bulletins do |t|
      t.string :title
      t.text :content
      t.datetime :display_until
      t.integer :creator_id

      t.timestamps
    end
  end
end
