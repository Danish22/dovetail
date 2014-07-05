# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140705213145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invoicing_ledger_items", force: true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "type"
    t.datetime "issue_date"
    t.string   "currency",     limit: 3,                           null: false
    t.decimal  "total_amount",            precision: 20, scale: 4
    t.decimal  "tax_amount",              precision: 20, scale: 4
    t.string   "status",       limit: 20
    t.string   "identifier",   limit: 50
    t.string   "description"
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "uuid",         limit: 40
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoicing_line_items", force: true do |t|
    t.integer  "ledger_item_id"
    t.string   "type"
    t.decimal  "net_amount",                precision: 20, scale: 4
    t.decimal  "tax_amount",                precision: 20, scale: 4
    t.string   "description"
    t.string   "uuid",           limit: 40
    t.datetime "tax_point"
    t.decimal  "quantity",                  precision: 20, scale: 4
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoicing_tax_rates", force: true do |t|
    t.string   "description"
    t.decimal  "rate",           precision: 20, scale: 4
    t.datetime "valid_from",                              null: false
    t.datetime "valid_until"
    t.integer  "replaced_by_id"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.integer  "space_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "members", ["space_id"], name: "index_members_on_space_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "space_members", force: true do |t|
    t.integer  "space_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "space_members", ["member_id"], name: "index_space_members_on_member_id", using: :btree
  add_index "space_members", ["space_id"], name: "index_space_members_on_space_id", using: :btree

  create_table "spaces", force: true do |t|
    t.string   "name"
    t.string   "address"
    t.string   "phone"
    t.string   "fax"
    t.string   "website"
    t.string   "country"
    t.string   "postal"
    t.string   "timezone"
    t.string   "currency"
    t.string   "slug"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spaces", ["user_id"], name: "index_spaces_on_user_id", using: :btree

  create_table "user_spaces", force: true do |t|
    t.integer  "user_id"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_spaces", ["space_id"], name: "index_user_spaces_on_space_id", using: :btree
  add_index "user_spaces", ["user_id"], name: "index_user_spaces_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
