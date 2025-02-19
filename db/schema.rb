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

ActiveRecord::Schema[8.0].define(version: 2025_02_19_180620) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.bigint "friend_id", null: false
    t.bigint "user_id", null: false
    t.bigint "service_category_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.string "status", default: "pending", null: false
    t.integer "total_amount_cents", default: 0, null: false
    t.string "total_amount_currency", default: "USD", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["friend_id", "end_time"], name: "index_bookings_on_friend_id_and_end_time"
    t.index ["friend_id", "start_time"], name: "index_bookings_on_friend_id_and_start_time"
    t.index ["friend_id"], name: "index_bookings_on_friend_id"
    t.index ["service_category_id"], name: "index_bookings_on_service_category_id"
    t.index ["status"], name: "index_bookings_on_status"
    t.index ["user_id", "status"], name: "index_bookings_on_user_id_and_status"
    t.index ["user_id"], name: "index_bookings_on_user_id"
    t.check_constraint "end_time > start_time", name: "end_time_after_start_time"
    t.check_constraint "status::text = ANY (ARRAY['pending'::character varying, 'confirmed'::character varying, 'completed'::character varying, 'cancelled'::character varying]::text[])", name: "valid_status"
  end

  create_table "friends", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.text "bio", null: false
    t.integer "hourly_rate_cents", default: 0, null: false
    t.string "hourly_rate_currency", default: "USD", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_friends_on_user_id", unique: true
  end

  create_table "friends_service_categories", id: false, force: :cascade do |t|
    t.bigint "friend_id", null: false
    t.bigint "service_category_id", null: false
    t.index ["friend_id", "service_category_id"], name: "index_friends_categories_on_friend_and_category", unique: true
    t.index ["service_category_id", "friend_id"], name: "index_friends_categories_on_category_and_friend"
  end

  create_table "service_categories", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_service_categories_on_name", unique: true
  end

  create_table "time_slots", force: :cascade do |t|
    t.bigint "friend_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.boolean "available", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["available"], name: "index_time_slots_on_available"
    t.index ["friend_id", "end_time"], name: "index_time_slots_on_friend_id_and_end_time"
    t.index ["friend_id", "start_time"], name: "index_time_slots_on_friend_id_and_start_time"
    t.index ["friend_id"], name: "index_time_slots_on_friend_id"
    t.check_constraint "end_time > start_time", name: "end_time_after_start_time"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bookings", "friends"
  add_foreign_key "bookings", "service_categories"
  add_foreign_key "bookings", "users"
  add_foreign_key "friends", "users"
  add_foreign_key "time_slots", "friends"
end
