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

ActiveRecord::Schema.define(:version => 20130317145129) do

  create_table "adapters", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.string   "_type"
    t.string   "service_id"
    t.string   "api_key"
  end

  create_table "notes", :force => true do |t|
    t.string   "title"
    t.text     "content_raw"
    t.text     "content_markdown"
    t.text     "content_html"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "guid"
    t.string   "content_hash"
    t.string   "user_id"
    t.string   "tag_ids"
  end

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.string   "note_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.integer  "sign_in_count",      :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.string   "notebook_name"
  end

end
