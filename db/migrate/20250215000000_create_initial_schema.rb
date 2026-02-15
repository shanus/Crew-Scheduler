class CreateInitialSchema < ActiveRecord::Migration[8.0]
  def up
    # This Baseline Migration represents the Rails 2.3 schema state.
    # It creates tables ONLY if they don't exist, making it safe for in-place upgrades.

    create_table "boat_usages", if_not_exists: true do |t|
      t.string   "name",       limit: 20, default: "recreation"
      t.timestamps
    end

    create_table "boat_weights", if_not_exists: true do |t|
      t.string   "name",       limit: 20, default: "mwt"
      t.timestamps
    end

    create_table "boats", if_not_exists: true do |t|
      t.string  "name",                         default: "",   null: false
      t.string  "hull_type",      limit: 10, default: "4+", null: false
      t.integer "boat_weight_id",               default: 2
      t.integer "boat_usage_id",                default: 4
      t.string  "color"
    end

    create_table "bulletins", if_not_exists: true do |t|
      t.string   "title",         limit: 150
      t.text     "body"
      t.date     "display_until"
      t.integer  "user_id"
      t.timestamps
    end

    create_table "events", if_not_exists: true do |t|
      t.date     "event_on"
      t.datetime "start_time"
      t.datetime "end_time"
      t.integer  "team_id"
      t.integer  "boat_id"
      t.timestamps
      t.string   "coxswain"
      t.string   "coach"
    end

    create_table "seating_positions", if_not_exists: true do |t|
      t.integer "event_id"
      t.integer "user_id"
      t.integer "position"
    end

    create_table "teams", if_not_exists: true do |t|
      t.string  "name",          limit: 50, default: "",    null: false
      t.boolean "require_cox",                 default: false
      t.boolean "require_coach",               default: false
      t.string  "color"
      t.boolean "active",                      default: true
    end

    create_table "tides", if_not_exists: true do |t|
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

    create_table "users", if_not_exists: true do |t|
      t.string   "login"
      t.string   "email"
      t.string   "side"
      t.string   "crypted_password",          limit: 40
      t.string   "salt",                      limit: 40
      t.timestamps
      t.string   "remember_token"
      t.datetime "remember_token_expires_at"
      t.string   "activation_code",           limit: 40
      t.datetime "activated_at"
      t.integer  "team_id",                                 default: 0
      t.boolean  "will_cox",                                default: false
      t.boolean  "will_coach",                              default: false
      t.boolean  "send_reminders",                          default: false
      t.boolean  "public_rowing_history",                   default: false
      t.string   "color"
      t.string   "time_zone"
    end
  end

  def down
    # No-op to avoid accidental destruction of legacy data
  end
end
