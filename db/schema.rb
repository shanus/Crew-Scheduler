# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_02_15_000001) do
  create_table "boat_usages", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name", limit: 20, default: "recreation"
    t.datetime "updated_at", precision: nil
  end

  create_table "boat_weights", force: :cascade do |t|
    t.datetime "created_at", precision: nil
    t.string "name", limit: 20, default: "mwt"
    t.datetime "updated_at", precision: nil
  end

  create_table "boats", force: :cascade do |t|
    t.integer "boat_usage_id", default: 4
    t.integer "boat_weight_id", default: 2
    t.string "color", limit: 255
    t.datetime "created_at"
    t.string "hull_type", limit: 10, default: "4+", null: false
    t.string "name", limit: 255, default: "", null: false
    t.datetime "updated_at"
  end

  create_table "bulletins", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", precision: nil
    t.date "display_until"
    t.string "title", limit: 150
    t.datetime "updated_at", precision: nil
    t.integer "user_id"
  end

  create_table "events", force: :cascade do |t|
    t.integer "boat_id"
    t.string "coach", limit: 255
    t.string "coxswain", limit: 255
    t.datetime "created_at", precision: nil
    t.datetime "end_time", precision: nil
    t.date "event_on"
    t.datetime "start_time", precision: nil
    t.integer "team_id"
    t.datetime "updated_at", precision: nil
  end

  create_table "seating_positions", force: :cascade do |t|
    t.datetime "created_at"
    t.integer "event_id"
    t.integer "position"
    t.datetime "updated_at"
    t.integer "user_id"
  end

  create_table "teams", force: :cascade do |t|
    t.boolean "active", default: true
    t.string "color", limit: 255
    t.datetime "created_at"
    t.string "name", limit: 50, default: "", null: false
    t.boolean "require_coach", default: false
    t.boolean "require_cox", default: false
    t.datetime "updated_at"
  end

  create_table "tides", force: :cascade do |t|
    t.datetime "created_at"
    t.date "day"
    t.datetime "first_high", precision: nil
    t.datetime "first_low", precision: nil
    t.datetime "first_mark_falling", precision: nil
    t.datetime "first_mark_rising", precision: nil
    t.datetime "second_high", precision: nil
    t.datetime "second_low", precision: nil
    t.datetime "second_mark_falling", precision: nil
    t.datetime "second_mark_rising", precision: nil
    t.datetime "sunrise", precision: nil
    t.datetime "sunset", precision: nil
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "activated_at", precision: nil
    t.string "activation_code", limit: 40
    t.string "color", limit: 255
    t.datetime "created_at", precision: nil
    t.string "crypted_password", limit: 40
    t.string "email", limit: 255
    t.string "login", limit: 255
    t.string "password_digest"
    t.boolean "public_rowing_history", default: false
    t.string "remember_token", limit: 255
    t.datetime "remember_token_expires_at", precision: nil
    t.string "salt", limit: 40
    t.boolean "send_reminders", default: false
    t.string "side", limit: 255
    t.integer "team_id", default: 0
    t.string "time_zone", limit: 255
    t.datetime "updated_at", precision: nil
    t.boolean "will_coach", default: false
    t.boolean "will_cox", default: false
  end
end
