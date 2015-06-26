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

ActiveRecord::Schema.define(version: 20150625140930) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "content_blocks", force: :cascade do |t|
    t.string   "content_path"
    t.text     "content"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.string   "api_key"
  end

  add_index "content_blocks", ["api_key", "content_path"], name: "index_content_blocks_on_api_key_and_content_path", unique: true, using: :btree
  add_index "content_blocks", ["api_key"], name: "index_content_blocks_on_api_key", using: :btree

  create_table "credential_pairs", force: :cascade do |t|
    t.string   "private_api_key", null: false
    t.string   "api_key",         null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "credential_pairs", ["api_key"], name: "index_credential_pairs_on_api_key", using: :btree
  add_index "credential_pairs", ["private_api_key"], name: "index_credential_pairs_on_private_api_key", unique: true, using: :btree

end
