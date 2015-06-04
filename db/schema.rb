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

ActiveRecord::Schema.define(version: 20150604155854) do

  create_table "relationships", force: :cascade do |t|
    t.integer  "follower_id", limit: 4
    t.integer  "followed_id", limit: 4
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "relationships", ["followed_id"], name: "index_relationships_on_followed_id", using: :btree
  add_index "relationships", ["follower_id", "followed_id"], name: "index_relationships_on_follower_id_and_followed_id", unique: true, using: :btree
  add_index "relationships", ["follower_id"], name: "index_relationships_on_follower_id", using: :btree

  create_table "ride_transactions", force: :cascade do |t|
    t.integer  "ride_id",        limit: 4
    t.integer  "user_id",        limit: 4
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "from_address",   limit: 255
    t.float    "from_latitude",  limit: 24
    t.float    "from_longitude", limit: 24
    t.string   "to_address",     limit: 255
    t.float    "to_latitude",    limit: 24
    t.float    "to_longitude",   limit: 24
    t.boolean  "isactive",       limit: 1,   default: true
    t.datetime "timeofride"
    t.float    "distance",       limit: 24
    t.float    "cost",           limit: 24
  end

  add_index "ride_transactions", ["user_id", "ride_id"], name: "index_ride_transactions_on_user_id_and_ride_id", using: :btree

  create_table "rides", force: :cascade do |t|
    t.string   "from_address",    limit: 255
    t.float    "from_latitude",   limit: 24
    t.float    "from_longitude",  limit: 24
    t.string   "to_address",      limit: 255
    t.float    "to_latitude",     limit: 24
    t.float    "to_longitude",    limit: 24
    t.datetime "timeofride"
    t.string   "car_description", limit: 255
    t.integer  "seats_available", limit: 4
    t.datetime "created_at",                                 null: false
    t.datetime "updated_at",                                 null: false
    t.integer  "user_id",         limit: 4
    t.boolean  "isactive",        limit: 1,   default: true
    t.integer  "seats_remaining", limit: 4
  end

  add_index "rides", ["user_id"], name: "index_rides_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "name",               limit: 255
    t.string   "email",              limit: 255
    t.string   "crypted_password",   limit: 255
    t.string   "password_salt",      limit: 255
    t.string   "persistence_token",  limit: 255
    t.integer  "login_count",        limit: 4
    t.integer  "failed_login_count", limit: 4
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip",   limit: 255
    t.string   "last_login_ip",      limit: 255
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

end
