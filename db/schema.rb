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

ActiveRecord::Schema[7.0].define(version: 2023_11_10_094026) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "banner_images", force: :cascade do |t|
    t.jsonb "image_data"
    t.text "image_credit"
    t.bigint "location_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_banner_images_on_location_id"
  end

  create_table "channel_members", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "channel_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_active"
    t.index ["channel_id"], name: "index_channel_members_on_channel_id"
    t.index ["user_id"], name: "index_channel_members_on_user_id"
  end

  create_table "channel_messages", force: :cascade do |t|
    t.text "body", null: false
    t.bigint "channel_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "deleted", default: false
    t.bigint "reply_to_id"
    t.index ["channel_id"], name: "index_channel_messages_on_channel_id"
    t.index ["reply_to_id"], name: "index_channel_messages_on_reply_to_id"
    t.index ["user_id"], name: "index_channel_messages_on_user_id"
  end

  create_table "channels", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "last_action_at"
  end

  create_table "countries", force: :cascade do |t|
    t.text "name", null: false
    t.integer "region_id"
    t.text "visa_summary_information"
    t.index ["region_id"], name: "index_countries_on_region_id"
  end

  create_table "eligible_countries_for_visas", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.bigint "visa_id", null: false
    t.index ["country_id"], name: "index_eligible_countries_for_visas_on_country_id"
    t.index ["visa_id"], name: "index_eligible_countries_for_visas_on_visa_id"
  end

  create_table "locations", force: :cascade do |t|
    t.text "name", null: false
    t.text "name_utf8", null: false
    t.integer "population"
    t.integer "country_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["country_id"], name: "index_locations_on_country_id"
    t.index ["name"], name: "index_locations_on_name"
  end

  create_table "regions", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "location_id", null: false
    t.text "body"
    t.integer "overall", null: false
    t.integer "fun", null: false
    t.integer "cost", null: false
    t.integer "internet", null: false
    t.integer "safety", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_reviews_on_location_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
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
    t.boolean "admin", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "display_name", null: false
    t.text "stripe_customer_id"
    t.text "last_checkout_reference"
    t.text "subscription_status"
    t.text "stream_user_id"
    t.text "stream_user_token"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "visas", force: :cascade do |t|
    t.bigint "country_id", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_visas_on_country_id"
  end

  add_foreign_key "banner_images", "locations"
  add_foreign_key "channel_messages", "channel_messages", column: "reply_to_id"
end
