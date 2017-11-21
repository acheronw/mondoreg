# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171121160710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "access_levels"
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
    t.index ["unlock_token"], name: "index_admin_users_on_unlock_token", unique: true, using: :btree
  end

  create_table "bank_transactions", force: :cascade do |t|
    t.string   "csv_line"
    t.float    "amount_of_transaction"
    t.date     "date_of_transaction"
    t.string   "comment_of_transaction"
    t.string   "sender_of_transaction"
    t.string   "order_id_code"
    t.integer  "ticket_order_id"
    t.string   "status"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "problem"
    t.index ["csv_line"], name: "index_bank_transactions_on_csv_line", unique: true, using: :btree
    t.index ["ticket_order_id"], name: "index_bank_transactions_on_ticket_order_id", using: :btree
  end

  create_table "comp_applications", force: :cascade do |t|
    t.integer  "competition_id"
    t.integer  "user_id"
    t.string   "character_name"
    t.string   "character_source"
    t.string   "status"
    t.string   "perf_requests"
    t.text     "group_members"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.text     "admin_msg"
    t.string   "primary_image_file_name"
    t.string   "primary_image_content_type"
    t.integer  "primary_image_file_size"
    t.datetime "primary_image_updated_at"
    t.string   "stage_music_file_name"
    t.string   "stage_music_content_type"
    t.integer  "stage_music_file_size"
    t.datetime "stage_music_updated_at"
    t.boolean  "veteran"
    t.string   "extra_image1_file_name"
    t.string   "extra_image1_content_type"
    t.integer  "extra_image1_file_size"
    t.datetime "extra_image1_updated_at"
    t.string   "extra_image2_file_name"
    t.string   "extra_image2_content_type"
    t.integer  "extra_image2_file_size"
    t.datetime "extra_image2_updated_at"
    t.integer  "appearance_no"
    t.string   "group_name"
    t.string   "nickname"
    t.text     "inner_memo"
    t.index ["competition_id"], name: "index_comp_applications_on_competition_id", using: :btree
    t.index ["user_id", "competition_id"], name: "index_comp_applications_on_user_id_and_competition_id", unique: true, using: :btree
    t.index ["user_id"], name: "index_comp_applications_on_user_id", using: :btree
  end

  create_table "competitions", force: :cascade do |t|
    t.string   "name"
    t.integer  "convention_id"
    t.string   "subtype"
    t.integer  "max_group_size"
    t.datetime "applications_start"
    t.datetime "applications_end"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "admin_email"
    t.integer  "max_applications"
    t.string   "welcome_info"
    t.index ["convention_id"], name: "index_competitions_on_convention_id", using: :btree
  end

  create_table "conventions", force: :cascade do |t|
    t.string   "name"
    t.datetime "opening"
    t.datetime "relevance_date"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name", "resource_type", "resource_id"], name: "index_roles_on_name_and_resource_type_and_resource_id", using: :btree
    t.index ["name"], name: "index_roles_on_name", using: :btree
  end

  create_table "ticket_orders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "ticket_id"
    t.integer  "quantity"
    t.string   "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_orders_on_ticket_id", using: :btree
    t.index ["user_id"], name: "index_ticket_orders_on_user_id", using: :btree
  end

  create_table "tickets", force: :cascade do |t|
    t.string   "name"
    t.integer  "convention_id"
    t.datetime "sale_start"
    t.datetime "sale_end"
    t.decimal  "price"
    t.integer  "quantity"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["convention_id"], name: "index_tickets_on_convention_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "name"
    t.string   "language"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "users_roles", id: false, force: :cascade do |t|
    t.integer "user_id"
    t.integer "role_id"
    t.index ["user_id", "role_id"], name: "index_users_roles_on_user_id_and_role_id", using: :btree
  end

  add_foreign_key "bank_transactions", "ticket_orders"
  add_foreign_key "comp_applications", "competitions"
  add_foreign_key "comp_applications", "users"
  add_foreign_key "competitions", "conventions"
  add_foreign_key "ticket_orders", "tickets"
  add_foreign_key "ticket_orders", "users"
  add_foreign_key "tickets", "conventions"
end
