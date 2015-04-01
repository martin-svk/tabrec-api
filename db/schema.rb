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

ActiveRecord::Schema.define(version: 20150401091145) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "advices", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "advices", ["name"], name: "index_advices_on_name", using: :btree

  create_table "events", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "events", ["name"], name: "index_events_on_name", using: :btree

  create_table "logs", force: :cascade do |t|
    t.string   "user_id"
    t.integer  "advice_id"
    t.integer  "resolution_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pattern_id"
  end

  create_table "patterns", force: :cascade do |t|
    t.string   "sequence"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "advice_id"
    t.string   "desc"
    t.string   "name"
  end

  add_index "patterns", ["name"], name: "index_patterns_on_name", using: :btree

  create_table "resolutions", force: :cascade do |t|
    t.string   "name"
    t.text     "desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resolutions", ["name"], name: "index_resolutions_on_name", using: :btree

  create_table "usage_logs", force: :cascade do |t|
    t.string   "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.integer  "tab_id"
    t.integer  "timestamp",  limit: 8
    t.integer  "window_id"
    t.integer  "index_from"
    t.integer  "index_to"
    t.string   "url"
    t.string   "session_id"
    t.string   "domain"
    t.string   "path"
    t.string   "subdomain"
  end

  create_table "users", force: :cascade do |t|
    t.string   "experience"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "rec_mode"
    t.boolean  "other_plugins", default: false, null: false
  end

end
