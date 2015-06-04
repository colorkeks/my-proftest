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

ActiveRecord::Schema.define(version: 20150601064548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "answers", force: :cascade do |t|
    t.boolean  "correct",       default: false
    t.text     "text"
    t.integer  "point"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "associations", force: :cascade do |t|
    t.text     "text"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "chains", force: :cascade do |t|
    t.integer  "test_id",     null: false
    t.integer  "section_id"
    t.integer  "eqvgroup_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "chains", ["test_id"], name: "index_chains_on_test_id", using: :btree

  create_table "eqvgroups", force: :cascade do |t|
    t.integer  "test_id",                null: false
    t.integer  "section_id"
    t.integer  "number",     default: 1, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "eqvgroups", ["section_id"], name: "index_eqvgroups_on_section_id", using: :btree
  add_index "eqvgroups", ["test_id", "number"], name: "index_eqvgroups_on_test_id_and_number", unique: true, using: :btree
  add_index "eqvgroups", ["test_id"], name: "index_eqvgroups_on_test_id", using: :btree

  create_table "roles", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.integer  "test_id"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sections", ["test_id"], name: "index_sections_on_test_id", using: :btree

  create_table "task_contents", force: :cascade do |t|
    t.string   "file_content_file_name"
    t.string   "file_content_content_type"
    t.integer  "file_content_file_size"
    t.datetime "file_content_updated_at"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "task_results", force: :cascade do |t|
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

  create_table "tasks", force: :cascade do |t|
    t.text     "text"
    t.text     "hint"
    t.string   "task_type"
    t.integer  "point"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "section_id"
    t.integer  "eqvgroup_id",    null: false
    t.datetime "deleted_at"
    t.integer  "chain_id"
    t.integer  "chain_position"
  end

  add_index "tasks", ["chain_id", "chain_position"], name: "index_tasks_on_chain_id_and_chain_position", unique: true, using: :btree
  add_index "tasks", ["deleted_at"], name: "index_tasks_on_deleted_at", using: :btree
  add_index "tasks", ["eqvgroup_id"], name: "index_tasks_on_eqvgroup_id", using: :btree
  add_index "tasks", ["section_id"], name: "index_tasks_on_section_id", using: :btree

  create_table "test_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "parent_id"
    t.integer  "lft",                    null: false
    t.integer  "rgt",                    null: false
    t.integer  "depth",      default: 0, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.datetime "deleted_at"
  end

  add_index "test_groups", ["lft"], name: "index_test_groups_on_lft", using: :btree
  add_index "test_groups", ["parent_id"], name: "index_test_groups_on_parent_id", using: :btree
  add_index "test_groups", ["rgt"], name: "index_test_groups_on_rgt", using: :btree

  create_table "tests", force: :cascade do |t|
    t.boolean  "directory",     default: false
    t.boolean  "attestation",   default: false
    t.string   "algorithm"
    t.integer  "percent_tasks"
    t.string   "title"
    t.time     "timer"
    t.text     "description"
    t.integer  "user_id"
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "test_group_id"
    t.datetime "deleted_at"
  end

  add_index "tests", ["test_group_id"], name: "index_tests_on_test_group_id", using: :btree

  create_table "tries", force: :cascade do |t|
    t.date     "date"
    t.float    "rate"
    t.string   "status",             default: "Не выполнен"
    t.time     "timer"
    t.text     "task_results_queue"
    t.integer  "user_id"
    t.integer  "test_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_answers", force: :cascade do |t|
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

  create_table "user_associations", force: :cascade do |t|
    t.text     "text"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.integer  "association_id"
    t.integer  "task_result_id"
    t.integer  "user_answer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "second_name"
    t.text     "attestation_tests"
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
