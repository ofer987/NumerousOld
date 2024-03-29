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

ActiveRecord::Schema.define(:version => 20120219225833) do

  create_table "fichiers", :force => true do |t|
    t.integer  "photo_id",         :null => false
    t.integer  "filesize_type_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "filesize_types", :force => true do |t|
    t.string   "name",       :null => false
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "title",                                          :null => false
    t.text     "description",                                    :null => false
    t.datetime "taken_date",  :default => '2012-02-20 01:13:18', :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "filename",    :default => "",                    :null => false
  end

  create_table "phototags", :force => true do |t|
    t.integer  "photo_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
