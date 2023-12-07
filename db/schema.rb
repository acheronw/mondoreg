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

ActiveRecord::Schema.define(version: 2023_12_07_110930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_id", null: false
    t.string "resource_type", null: false
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "access_levels"
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true
  end

  create_table "bank_transactions", id: :serial, force: :cascade do |t|
    t.string "csv_line"
    t.float "amount_of_transaction"
    t.date "date_of_transaction"
    t.string "comment_of_transaction"
    t.string "sender_of_transaction"
    t.string "order_id_code"
    t.integer "ticket_order_id"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "problem"
    t.index ["csv_line"], name: "index_bank_transactions_on_csv_line", unique: true
    t.index ["ticket_order_id"], name: "index_bank_transactions_on_ticket_order_id"
  end

  create_table "booths", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "convention_id", null: false
    t.integer "booth_number"
    t.string "booth_name"
    t.string "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["convention_id"], name: "index_booths_on_convention_id"
    t.index ["user_id"], name: "index_booths_on_user_id"
  end

  create_table "comp_applications", id: :serial, force: :cascade do |t|
    t.integer "competition_id"
    t.integer "user_id"
    t.string "character_name"
    t.string "character_source"
    t.string "status"
    t.string "perf_requests"
    t.text "group_members"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "admin_msg"
    t.boolean "veteran"
    t.integer "appearance_no"
    t.string "group_name"
    t.string "nickname"
    t.text "inner_memo"
    t.string "selected_music"
    t.boolean "age"
    t.string "karaoke1"
    t.string "karaoke2"
    t.integer "age_in_years"
    t.string "combo_comp"
    t.string "schedule_picked"
    t.string "title"
    t.string "description"
    t.boolean "includes_effects"
    t.string "music_description"
    t.index ["competition_id"], name: "index_comp_applications_on_competition_id"
    t.index ["user_id", "competition_id"], name: "index_comp_applications_on_user_id_and_competition_id", unique: true
    t.index ["user_id"], name: "index_comp_applications_on_user_id"
  end

  create_table "competitions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "convention_id"
    t.string "subtype"
    t.integer "max_group_size"
    t.datetime "applications_start"
    t.datetime "applications_end"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "admin_email"
    t.integer "max_applications"
    t.string "welcome_info"
    t.string "combo_comp"
    t.string "schedule_options"
    t.integer "ppl_per_schedule"
    t.index ["convention_id"], name: "index_competitions_on_convention_id"
  end

  create_table "conventions", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "opening"
    t.datetime "relevance_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "booth_limit"
    t.datetime "aa_opening_time"
  end

  create_table "mondo_sub_attribs", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mondo_subs_mails", force: :cascade do |t|
    t.string "sub_name"
    t.integer "sub_zip"
    t.string "sub_city"
    t.string "sub_address"
    t.datetime "sub_mail_date"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "mondo_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "name"
    t.string "status"
    t.integer "duration"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_mondo_subscriptions_on_user_id"
  end

  create_table "postages", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "item"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_postages_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "resource_type"
    t.integer "resource_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id"
    t.index ["name"], name: "index_roles_on_name"
    t.index ["resource_type", "resource_id"], name: "index_roles_on_resource"
  end

  create_table "ticket_orders", id: :integer, default: -> { "bounded_pseudo_encrypt((nextval('ticket_orders_id_seq'::regclass))::integer, 16777215, 30000)" }, force: :cascade do |t|
    t.integer "user_id"
    t.integer "ticket_id"
    t.integer "quantity"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "deliverer"
    t.string "payment_type"
    t.datetime "payment_date"
    t.index ["ticket_id"], name: "index_ticket_orders_on_ticket_id"
    t.index ["user_id"], name: "index_ticket_orders_on_user_id"
  end

  create_table "tickets", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "convention_id"
    t.datetime "sale_start"
    t.datetime "sale_end"
    t.decimal "price"
    t.integer "quantity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["convention_id"], name: "index_tickets_on_convention_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.string "language"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "privacy_accepted", default: false
    t.string "subscription_email"
    t.string "subscription_name"
    t.integer "subscription_zip"
    t.string "subscription_city"
    t.string "subscription_address"
    t.integer "subscription_uptime"
    t.string "subscription_comment"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["role_id"], name: "index_users_roles_on_role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id"
    t.index ["user_id"], name: "index_users_roles_on_user_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "bank_transactions", "ticket_orders"
  add_foreign_key "booths", "conventions"
  add_foreign_key "booths", "users"
  add_foreign_key "comp_applications", "competitions"
  add_foreign_key "comp_applications", "users"
  add_foreign_key "competitions", "conventions"
  add_foreign_key "mondo_subscriptions", "users"
  add_foreign_key "postages", "users"
  add_foreign_key "ticket_orders", "tickets"
  add_foreign_key "ticket_orders", "users"
  add_foreign_key "tickets", "conventions"
end
