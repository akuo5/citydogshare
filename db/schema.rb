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

ActiveRecord::Schema.define(version: 20161127234259) do

  create_table "admins", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "barks", force: :cascade do |t|
    t.string "value"
  end

  create_table "dog_bark_linkers", force: :cascade do |t|
    t.integer "dog_id"
    t.integer "bark_id"
  end

  create_table "dog_like_linkers", force: :cascade do |t|
    t.integer "dog_id"
    t.integer "like_id"
  end

  create_table "dog_mix_linkers", force: :cascade do |t|
    t.integer "dog_id"
    t.integer "mix_id"
  end

  create_table "dog_personality_linkers", force: :cascade do |t|
    t.integer "dog_id"
    t.integer "personality_id"
  end

  create_table "dogs", force: :cascade do |t|
    t.string   "name"
    t.string   "image"
    t.datetime "dob"
    t.string   "description"
    t.string   "motto"
    t.boolean  "fixed"
    t.string   "health"
    t.string   "availability"
    t.string   "gender"
    t.integer  "size_id"
    t.integer  "energy_level_id"
    t.integer  "user_id"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "token"
    t.string   "video"
    t.boolean  "chipped"
    t.boolean  "shots_to_date"
  end

  create_table "dogs_events", id: false, force: :cascade do |t|
    t.integer "dog_id"
    t.integer "event_id"
  end

  add_index "dogs_events", ["dog_id"], name: "index_dogs_events_on_dog_id"
  add_index "dogs_events", ["event_id"], name: "index_dogs_events_on_event_id"

  create_table "energy_levels", force: :cascade do |t|
    t.string "value"
  end

  create_table "events", force: :cascade do |t|
    t.date    "start_date"
    t.date    "end_date"
    t.string  "time_of_day"
    t.string  "location_id"
    t.string  "description"
    t.integer "user_id"
    t.boolean "filled"
  end

  create_table "likes", force: :cascade do |t|
    t.string "value"
  end

  create_table "locations", force: :cascade do |t|
    t.string "value"
  end

  create_table "mixes", force: :cascade do |t|
    t.string "value"
  end

  create_table "personalities", force: :cascade do |t|
    t.string "value"
  end

  create_table "pictures", force: :cascade do |t|
    t.string   "description"
    t.string   "image"
    t.integer  "dog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "dogs_token"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "sizes", force: :cascade do |t|
    t.string "value"
  end

  create_table "stars", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "dog_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "stars", ["user_id"], name: "index_stars_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "uid"
    t.string   "name"
    t.string   "oauth_token"
    t.datetime "oauth_expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "last_name"
    t.string   "first_name"
    t.string   "location"
    t.string   "gender"
    t.string   "image"
    t.string   "status"
    t.string   "phone_number"
    t.string   "email"
    t.string   "description"
    t.string   "availability"
    t.string   "address"
    t.string   "zipcode"
    t.string   "city"
    t.string   "country"
    t.boolean  "is_pro"
  end

end
