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

ActiveRecord::Schema.define(version: 20161010105016) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body"
    t.string   "resource_id",   limit: 255, null: false
    t.string   "resource_type", limit: 255, null: false
    t.integer  "author_id"
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "bookings", force: :cascade do |t|
    t.integer  "space_id"
    t.integer  "location_id"
    t.integer  "meetingroom_id"
    t.integer  "member_id"
    t.datetime "starting"
    t.datetime "ending"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",           limit: 255, null: false
    t.integer  "sluggable_id",               null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope",          limit: 255
    t.datetime "created_at"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
  add_index "friendly_id_slugs", ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
  add_index "friendly_id_slugs", ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
  add_index "friendly_id_slugs", ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree

  create_table "integrations", force: :cascade do |t|
    t.string   "type",                limit: 255
    t.string   "api_key",             limit: 255
    t.string   "api_secret",          limit: 255
    t.string   "oauth_access_token",  limit: 255
    t.string   "oauth_refresh_token", limit: 255
    t.string   "remote_account_id",   limit: 255
    t.text     "settings"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invites", force: :cascade do |t|
    t.integer  "recipient_id"
    t.integer  "sender_id"
    t.integer  "space_id"
    t.string   "email",        limit: 255
    t.string   "token",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invoicing_ledger_items", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.string   "type",         limit: 255
    t.datetime "issue_date"
    t.string   "currency",     limit: 3,                            null: false
    t.decimal  "total_amount",             precision: 20, scale: 4
    t.decimal  "tax_amount",               precision: 20, scale: 4
    t.string   "status",       limit: 20
    t.string   "identifier",   limit: 50
    t.string   "description",  limit: 255
    t.datetime "period_start"
    t.datetime "period_end"
    t.string   "uuid",         limit: 40
    t.datetime "due_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id"
    t.integer  "plan_id"
    t.datetime "paid_at"
  end

  create_table "invoicing_line_items", force: :cascade do |t|
    t.integer  "ledger_item_id"
    t.string   "type",           limit: 255
    t.decimal  "net_amount",                 precision: 20, scale: 4
    t.decimal  "tax_amount",                 precision: 20, scale: 4
    t.string   "description",    limit: 255
    t.string   "uuid",           limit: 40
    t.datetime "tax_point"
    t.decimal  "quantity",                   precision: 20, scale: 4
    t.integer  "creator_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "tax_rate",                   precision: 8,  scale: 4
    t.decimal  "unit_price",                 precision: 20, scale: 4
  end

  create_table "invoicing_tax_rates", force: :cascade do |t|
    t.string   "description",    limit: 255
    t.decimal  "rate",                       precision: 20, scale: 4
    t.datetime "valid_from",                                          null: false
    t.datetime "valid_until"
    t.integer  "replaced_by_id"
    t.boolean  "is_default"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "locations", force: :cascade do |t|
    t.string   "city",        limit: 255
    t.string   "state",       limit: 255
    t.string   "postal_code", limit: 255
    t.string   "country",     limit: 255
    t.string   "timezone",    limit: 255
    t.string   "currency",    limit: 255
    t.decimal  "tax_rate"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name",        limit: 255
    t.string   "address",     limit: 255
  end

  create_table "meetingrooms", force: :cascade do |t|
    t.integer  "space_id"
    t.integer  "location_id"
    t.string   "name",        limit: 255
    t.string   "description", limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_identities", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "email",           limit: 255
    t.string   "subdomain",       limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "member_messages", force: :cascade do |t|
    t.integer  "message_id"
    t.integer  "member_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "members", force: :cascade do |t|
    t.string   "name",                       limit: 255
    t.string   "email",                      limit: 255
    t.integer  "space_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "location_id"
    t.integer  "plan_id"
    t.string   "provider",                   limit: 255
    t.string   "uid",                        limit: 255
    t.string   "invite",                     limit: 255
    t.string   "payment_system_customer_id", limit: 255
    t.string   "last_4_digits",              limit: 255
    t.string   "slug",                       limit: 255
    t.datetime "last_scheduled_invoice_at"
    t.string   "status"
  end

  add_index "members", ["slug"], name: "index_members_on_slug", unique: true, using: :btree
  add_index "members", ["space_id"], name: "index_members_on_space_id", using: :btree
  add_index "members", ["user_id"], name: "index_members_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.integer  "space_id"
    t.integer  "user_id"
    t.string   "subject",    limit: 255
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string   "billing_name",  limit: 255
    t.string   "billing_email", limit: 255
    t.string   "company_name",  limit: 255
    t.string   "stripe_id",     limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_4_digits", limit: 255
  end

  add_index "payment_methods", ["user_id"], name: "index_payment_methods_on_user_id", using: :btree

  create_table "plan_resources", force: :cascade do |t|
    t.integer  "plan_id"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plan_resources", ["plan_id"], name: "index_plan_resources_on_plan_id", using: :btree
  add_index "plan_resources", ["resource_id"], name: "index_plan_resources_on_resource_id", using: :btree

  create_table "plans", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.decimal  "base_price"
    t.decimal  "setup_fee"
    t.decimal  "deposit"
    t.string   "frequency",   limit: 255
    t.integer  "space_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "plans", ["location_id"], name: "index_plans_on_location_id", using: :btree
  add_index "plans", ["space_id"], name: "index_plans_on_space_id", using: :btree

  create_table "que_jobs", id: false, force: :cascade do |t|
    t.integer  "priority",    limit: 2, default: 100,                                        null: false
    t.datetime "run_at",                default: "now()",                                    null: false
    t.integer  "job_id",      limit: 8, default: "nextval('que_jobs_job_id_seq'::regclass)", null: false
    t.text     "job_class",                                                                  null: false
    t.json     "args",                  default: [],                                         null: false
    t.integer  "error_count",           default: 0,                                          null: false
    t.text     "last_error"
    t.text     "queue",                 default: "",                                         null: false
  end

  create_table "resources", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.integer  "quantity"
    t.boolean  "unlimted"
    t.integer  "space_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["location_id"], name: "index_resources_on_location_id", using: :btree
  add_index "resources", ["space_id"], name: "index_resources_on_space_id", using: :btree

  create_table "spaces", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.string   "address",                limit: 255
    t.string   "phone",                  limit: 255
    t.string   "fax",                    limit: 255
    t.string   "website",                limit: 255
    t.string   "country",                limit: 255
    t.string   "postal",                 limit: 255
    t.string   "timezone",               limit: 255
    t.string   "currency",               limit: 255
    t.string   "slug",                   limit: 255
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "plan",                   limit: 255
    t.string   "stripe_subscription_id", limit: 255
    t.integer  "payment_method_id"
    t.string   "subdomain",              limit: 255
  end

  add_index "spaces", ["user_id"], name: "index_spaces_on_user_id", using: :btree

  create_table "user_spaces", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "space_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_spaces", ["space_id"], name: "index_user_spaces_on_space_id", using: :btree
  add_index "user_spaces", ["user_id"], name: "index_user_spaces_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "confirmation_token",     limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "trial_ending"
    t.string   "full_name",              limit: 255
    t.string   "first_name",             limit: 255
    t.string   "last_name",              limit: 255
    t.string   "promo_code",             limit: 255
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
