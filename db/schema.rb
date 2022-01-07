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

ActiveRecord::Schema.define(version: 2021_12_24_062842) do

  create_table "comments", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "soccer_field_id", null: false
    t.string "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["soccer_field_id"], name: "index_comments_on_soccer_field_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "notifications", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.string "notice_type"
    t.string "title"
    t.string "content"
    t.datetime "checked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "order_details", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.bigint "soccer_field_id", null: false
    t.bigint "current_price"
    t.string "booking_used"
    t.integer "type_field"
    t.date "order_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["order_id"], name: "index_order_details_on_order_id"
    t.index ["soccer_field_id"], name: "index_order_details_on_soccer_field_id"
  end

  create_table "orders", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "quantity"
    t.integer "status"
    t.bigint "total_cost"
    t.integer "is_payment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.date "order_date"
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "ratings", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "soccer_field_id", null: false
    t.integer "rating"
    t.integer "parent_id"
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["soccer_field_id"], name: "index_ratings_on_soccer_field_id"
    t.index ["user_id"], name: "index_ratings_on_user_id"
  end

  create_table "soccer_fields", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "field_name"
    t.integer "type_field"
    t.bigint "price"
    t.integer "status", default: 0
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "code"
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_unicode_ci", force: :cascade do |t|
    t.string "name"
    t.string "phone"
    t.string "country"
    t.string "address"
    t.string "provider"
    t.string "uid"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "reset_digest"
    t.datetime "reset_sent_at"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "soccer_fields"
  add_foreign_key "comments", "users"
  add_foreign_key "order_details", "orders"
  add_foreign_key "order_details", "soccer_fields"
  add_foreign_key "orders", "users"
  add_foreign_key "ratings", "soccer_fields"
  add_foreign_key "ratings", "users"
end
