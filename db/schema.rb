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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130227155315) do

  create_table "agendas", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.boolean  "finished"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "items", :force => true do |t|
    t.string   "name"
    t.integer  "position"
    t.string   "ancestry"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "projectors", :force => true do |t|
    t.string   "name"
    t.integer  "slide_id"
    t.boolean  "has_timer",  :default => true
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "slides", :force => true do |t|
    t.string   "name"
    t.string   "art"
    t.text     "data"
    t.string   "unique"
    t.integer  "item_id"
    t.integer  "agenda_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "slides", ["unique"], :name => "index_slides_on_unique", :unique => true

  create_table "timers", :force => true do |t|
    t.string   "name"
    t.integer  "default"
    t.integer  "position"
    t.boolean  "visable"
    t.string   "color",      :default => "00f"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "password_sec"
    t.text     "rights"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
