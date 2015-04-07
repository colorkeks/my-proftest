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

ActiveRecord::Schema.define(version: 20150330065201) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: true do |t|
    t.boolean  "correct",       default: false
    t.text     "text"
    t.integer  "point"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "associations", force: true do |t|
    t.text     "text"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_contents", force: true do |t|
    t.string   "file_content_file_name"
    t.string   "file_content_content_type"
    t.integer  "file_content_file_size"
    t.datetime "file_content_updated_at"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_results", force: true do |t|
    t.float    "point"
    t.string   "task_type"
    t.text     "text"
    t.text     "hint"
    t.string   "status"
    t.integer  "task_id"
    t.integer  "try_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", force: true do |t|
    t.text     "text"
    t.text     "hint"
    t.string   "task_type"
    t.integer  "point"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tests", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tries", force: true do |t|
    t.date     "date"
    t.float    "rate"
    t.text     "task_results_queue"
    t.integer  "user_id"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_answers", force: true do |t|
    t.string   "user_reply"
    t.boolean  "correct"
    t.text     "text"
    t.integer  "serial_number"
    t.float    "point"
    t.integer  "answer_id"
    t.integer  "task_id"
    t.integer  "user_association_id"
    t.integer  "task_result_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_associations", force: true do |t|
    t.text     "text"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.integer  "association_id"
    t.integer  "task_result_id"
    t.integer  "user_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "job"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
