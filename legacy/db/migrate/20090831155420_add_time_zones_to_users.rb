class AddTimeZonesToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :time_zone, :string
    for user in User.all
      user.update_attribute(:time_zone, "Eastern Time (US & Canada)")
    end
  end

  def self.down
    remove_column :users, :time_zone
  end
end
