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

ActiveRecord::Schema.define(version: 20160403074044) do

  create_table "banks", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "banks", ["name"], name: "index_banks_on_name", unique: true

  create_table "banks_cities", id: false, force: :cascade do |t|
    t.integer "city_id"
    t.integer "bank_id"
  end

  add_index "banks_cities", ["bank_id"], name: "index_banks_cities_on_bank_id"
  add_index "banks_cities", ["city_id"], name: "index_banks_cities_on_city_id"

  create_table "branches", force: :cascade do |t|
    t.string   "ifsc"
    t.integer  "given_bank_id"
    t.string   "branch"
    t.string   "address"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "city_id"
    t.integer  "bank_id"
  end

  add_index "branches", ["bank_id"], name: "index_branches_on_bank_id"
  add_index "branches", ["ifsc"], name: "index_branches_on_ifsc", unique: true

  create_table "cities", force: :cascade do |t|
    t.string   "name"
    t.string   "district"
    t.string   "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "cities", ["name"], name: "index_cities_on_name", unique: true

end
