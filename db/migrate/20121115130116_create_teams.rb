class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :require_cox
      t.boolean :require_coach
      t.string :color
      t.boolean :active, :default => true
      
      t.timestamps
    end
  end
end
