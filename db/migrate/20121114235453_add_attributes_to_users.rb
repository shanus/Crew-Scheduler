class AddAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authentication_token, :string
    add_column :users, :confirmation_token, :string
    add_column :users, :unconfirmed_email, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :side, :string
    add_column :users, :will_cox, :boolean
    add_column :users, :will_coach, :boolean
    add_column :users, :send_reminders, :boolean
    add_column :users, :public_rowing_history, :boolean
    add_column :users, :color, :string
    add_column :users, :time_zone, :string, :default => "Eastern Time (US & Canada)"
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string

  end
end
