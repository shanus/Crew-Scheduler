class CreateBulletins < ActiveRecord::Migration
  def self.up
    create_table :bulletins do |t|
      t.column :title, :string, :limit => "150"
      t.column :body, :text
      t.column :display_until, :date
      t.column :user_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :bulletins
  end
end
