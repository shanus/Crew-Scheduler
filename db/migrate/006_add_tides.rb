class AddTides < ActiveRecord::Migration
  
  def self.up
    create_table :tides do |t|
      t.column :day, :date
      t.column :sunrise, :time
      t.column :sunset, :time
      t.column :first_high, :time
      t.column :second_high, :time
      t.column :first_low, :time
      t.column :second_low, :time
      t.column :first_mark_rising, :time
      t.column :second_mark_rising, :time
      t.column :first_mark_falling, :time
      t.column :second_mark_falling, :time
    end
    Tide.import_tide_csv("#{RAILS_ROOT}/lib/csv_flatfiles/tides2.csv") if File.exist?("#{RAILS_ROOT}/lib/csv_flatfiles/tides2.csv")
  end

  def self.down
    drop_table :tides
  end
end
