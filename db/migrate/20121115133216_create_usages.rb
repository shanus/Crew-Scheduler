class CreateUsages < ActiveRecord::Migration
  def change
    create_table :usages do |t|
      t.string :name

      t.timestamps
    end
  end
end
