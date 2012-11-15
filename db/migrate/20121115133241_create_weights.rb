class CreateWeights < ActiveRecord::Migration
  def change
    create_table :weights do |t|
      t.string :name

      t.timestamps
    end
  end
end
