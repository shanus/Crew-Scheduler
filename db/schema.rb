# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090831155420) do

  create_table "boat_usages", :force => true do |t|
    t.string   "name",       :limit => 20, :default => "recreation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boat_weights", :force => true do |t|
    t.string   "name",       :limit => 20, :default => "mwt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "boats", :force => true do |t|
    t.string  "name",                         :default => "",   :null => false
    t.string  "hull_type",      :limit => 10, :default => "4+", :null => false
    t.integer "boat_weight_id",               :default => 2
    t.integer "boat_usage_id",                :default => 4
    t.string  "color"
  end

  create_table "bulletins", :force => true do |t|
    t.string   "title",         :limit => 150
    t.text     "body"
    t.date     "display_until"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.date     "event_on"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "team_id"
    t.integer  "boat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "coxswain"
    t.string   "coach"
  end

  create_table "seating_positions", :force => true do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "position"
  end

  create_table "teams", :force => true do |t|
    t.string  "name",          :limit => 50, :default => "",    :null => false
    t.boolean "require_cox",                 :default => false
    t.boolean "require_coach",               :default => false
    t.string  "color"
    t.boolean "active",                      :default => true
  end

  create_table "tides", :force => true do |t|
    t.date     "day"
    t.datetime "sunrise"
    t.datetime "sunset"
    t.datetime "first_high"
    t.datetime "second_high"
    t.datetime "first_low"
    t.datetime "second_low"
    t.datetime "first_mark_rising"
    t.datetime "second_mark_rising"
    t.datetime "first_mark_falling"
    t.datetime "second_mark_falling"
  end

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "side"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.integer  "team_id",                                 :default => 0
    t.boolean  "will_cox",                                :default => false
    t.boolean  "will_coach",                              :default => false
    t.boolean  "send_reminders",                          :default => false
    t.boolean  "public_rowing_history",                   :default => false
    t.string   "color"
    t.string   "time_zone"
  end

end
