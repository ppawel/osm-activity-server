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

ActiveRecord::Schema.define(:version => 20121002202058) do

  create_table "activities", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "published_at", :null => false
    t.string "actor_type", :null => false
    t.string "actor_id", :null => false
    t.string "actor_name", :null => false
    t.string "object_type", :null => false
    t.string "object_id", :null => false
    t.string "object_name"
    t.string "target_type", :null => false
    t.string "target_id"
    t.string "target_name"
    t.string "verb", :null => false
    t.string "title", :null => false
    t.string "content", :null => false
    t.point "latlon", :geographic => true
  end

  create_table :activity_recipients do |t|
    t.integer "activity_id", :null => false
    t.integer "osm_user_id", :null => false
  end
end
