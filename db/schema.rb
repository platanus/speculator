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

ActiveRecord::Schema.define(version: 20160317212408) do

  create_table "accounts", force: :cascade do |t|
    t.integer  "robot_id",                 limit: 4
    t.string   "name",                     limit: 255
    t.string   "exchange",                 limit: 255
    t.string   "base_currency",            limit: 255
    t.string   "quote_currency",           limit: 255
    t.text     "encrypted_credentials",    limit: 65535
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.string   "encrypted_credentials_iv", limit: 255
  end

  add_index "accounts", ["robot_id"], name: "index_accounts_on_robot_id", using: :btree

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
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
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   limit: 4,     default: 0, null: false
    t.integer  "attempts",   limit: 4,     default: 0, null: false
    t.text     "handler",    limit: 65535,             null: false
    t.text     "last_error", limit: 65535
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by",  limit: 255
    t.string   "queue",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "orders", force: :cascade do |t|
    t.integer  "account_id",      limit: 4
    t.string   "ex_id",           limit: 255
    t.float    "price",           limit: 24
    t.float    "volume",          limit: 24
    t.float    "pending_volume",  limit: 24
    t.float    "unsynced_volume", limit: 24,  default: 0.0
    t.integer  "instruction",     limit: 4
    t.datetime "closed_at"
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "base_currency",   limit: 255
    t.string   "quote_currency",  limit: 255
  end

  add_index "orders", ["account_id"], name: "index_orders_on_account_id", using: :btree

  create_table "robot_logs", force: :cascade do |t|
    t.integer  "robot_id",   limit: 4
    t.datetime "created_at"
    t.text     "message",    limit: 65535
    t.string   "level",      limit: 255
  end

  add_index "robot_logs", ["robot_id"], name: "index_robot_logs_on_robot_id", using: :btree

  create_table "robot_stats", force: :cascade do |t|
    t.integer  "robot_id",   limit: 4
    t.string   "name",       limit: 255
    t.float    "value",      limit: 24
    t.datetime "created_at",             null: false
  end

  add_index "robot_stats", ["robot_id"], name: "index_robot_stats_on_robot_id", using: :btree

  create_table "robots", force: :cascade do |t|
    t.string   "name",              limit: 255
    t.string   "engine",            limit: 255
    t.text     "config",            limit: 65535
    t.datetime "last_execution_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.float    "delay",             limit: 24
    t.datetime "started_at"
    t.datetime "next_execution_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "robot_logs", "robots"
  add_foreign_key "robot_stats", "robots"
end
