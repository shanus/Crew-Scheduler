class ModernizeToRails8 < ActiveRecord::Migration[8.0]
  def change
    # Add password_digest for BCrypt support (preserves crypted_password/salt)
    unless column_exists?(:users, :password_digest)
      add_column :users, :password_digest, :string
    end

    # Add missing timestamps to tables that lacked them
    %i[boats teams tides seating_positions].each do |table|
      unless column_exists?(table, :created_at)
        add_timestamps table, null: true
      end
    end
  end
end
