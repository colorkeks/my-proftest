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

ActiveRecord::Schema.define(version: 20150723061811) do

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

  create_table "assigned_tests", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "test_id"
    t.integer  "test_mode_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "associations", force: :cascade do |t|
    t.text     "text"
    t.integer  "serial_number"
    t.integer  "task_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "file_content_file_name"
    t.string   "file_content_content_type"
    t.integer  "file_content_file_size"
    t.datetime "file_content_updated_at"
    t.integer  "user_id"
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

  create_table "doctor_dbfs", force: :cascade do |t|
    t.string  "drcode",   limit: 8
    t.string  "dbsource", limit: 1
    t.integer "lpuwork"
    t.string  "surname",  limit: 24
    t.string  "name",     limit: 16
    t.string  "secname",  limit: 16
    t.string  "pension",  limit: 14
    t.date    "datebeg"
    t.date    "dateend"
  end

  add_index "doctor_dbfs", ["drcode"], name: "index_doctor_dbfs_on_drcode", using: :btree
  add_index "doctor_dbfs", ["name"], name: "index_doctor_dbfs_on_name", using: :btree
  add_index "doctor_dbfs", ["secname"], name: "index_doctor_dbfs_on_secname", using: :btree
  add_index "doctor_dbfs", ["surname"], name: "index_doctor_dbfs_on_surname", using: :btree

  create_table "eqvgroups", force: :cascade do |t|
    t.integer  "test_id",                 null: false
    t.integer  "section_id"
    t.integer  "number",      default: 1, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "task_count",  default: 0
    t.integer  "chain_count", default: 0
  end

  add_index "eqvgroups", ["section_id"], name: "index_eqvgroups_on_section_id", using: :btree
  add_index "eqvgroups", ["test_id", "number"], name: "index_eqvgroups_on_test_id_and_number", unique: true, using: :btree
  add_index "eqvgroups", ["test_id"], name: "index_eqvgroups_on_test_id", using: :btree

  create_table "lpu_dbfs", force: :cascade do |t|
    t.integer "lpucode"
    t.integer "type_s"
    t.string  "name",       limit: 128
    t.string  "name_l",     limit: 254
    t.string  "name_s",     limit: 60
    t.integer "oms"
    t.integer "pmsp_yes"
    t.integer "dent_yes"
    t.integer "age"
    t.string  "index",      limit: 6
    t.integer "ter"
    t.integer "orgn1"
    t.integer "orgn2"
    t.integer "orgn3"
    t.integer "razdel"
    t.integer "street"
    t.integer "house"
    t.string  "houseliter", limit: 1
    t.integer "corpus"
    t.integer "flat"
    t.string  "flatliter",  limit: 1
    t.string  "e_mail",     limit: 64
    t.string  "npost",      limit: 40
    t.string  "face",       limit: 48
    t.string  "phone"
    t.string  "fax"
    t.string  "face1",      limit: 48
    t.string  "phone1"
    t.string  "npost3",     limit: 40
    t.string  "face3",      limit: 48
    t.string  "e_mail3",    limit: 64
    t.string  "phone3"
    t.string  "inn",        limit: 12
    t.string  "ogrn",       limit: 15
    t.integer "owercode"
    t.string  "nn_lpu",     limit: 12
    t.integer "domain"
    t.integer "chief"
    t.integer "kopf"
    t.string  "ekatc",      limit: 8
    t.string  "okpo",       limit: 13
    t.string  "soato"
    t.string  "soogu"
    t.string  "kpp",        limit: 9
    t.date    "datebeg"
    t.date    "dateend"
    t.date    "datemod"
  end

  add_index "lpu_dbfs", ["lpucode"], name: "index_lpu_dbfs_on_lpucode", using: :btree

  create_table "officfun_dbfs", force: :cascade do |t|
    t.string  "drcode",   limit: 8
    t.integer "lpuwork"
    t.integer "speccode"
    t.string  "dbsource", limit: 1
    t.integer "postcode"
    t.date    "d_prik"
    t.date    "d_ser"
    t.integer "category"
    t.integer "drstatus"
    t.date    "date_b"
    t.date    "date_e"
    t.integer "right"
    t.string  "actpack",  limit: 3
    t.integer "change_r"
    t.date    "d_fin"
    t.date    "d_start"
    t.date    "d_modif"
    t.integer "deleted"
  end

  add_index "officfun_dbfs", ["drcode"], name: "index_officfun_dbfs_on_drcode", using: :btree

  create_table "post_dbfs", force: :cascade do |t|
    t.integer "postcode"
    t.integer "prvd_131"
    t.integer "prvd_53"
    t.string  "name",     limit: 64
    t.integer "speccode"
    t.integer "profcode"
    t.string  "actpack",  limit: 3
    t.integer "change_r"
    t.date    "d_fin"
    t.date    "d_start"
    t.date    "d_modif"
    t.integer "deleted"
  end

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

  create_table "speclist_dbfs", force: :cascade do |t|
    t.integer "speccode"
    t.string  "id_spec",   limit: 9
    t.string  "id_tfoms",  limit: 9
    t.integer "type_spec"
    t.string  "name",      limit: 64
    t.string  "actpack",   limit: 3
    t.integer "change_r"
    t.date    "d_fin"
    t.date    "d_start"
    t.date    "d_modif"
    t.integer "deleted"
  end

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
    t.integer  "task_version_id"
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

  create_table "test_modes", force: :cascade do |t|
    t.date     "date_beg"
    t.date     "date_end"
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tests", force: :cascade do |t|
    t.boolean  "directory",     default: false
    t.boolean  "attestation",   default: false
    t.string   "algorithm"
    t.integer  "percent_tasks"
    t.string   "title"
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
    t.boolean  "training"
    t.boolean  "can_change"
    t.boolean  "mix_tasks"
    t.boolean  "mix_answers"
    t.boolean  "limit_time"
    t.integer  "timer"
    t.integer  "default_point", default: 1
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
    t.integer  "test_mode_id"
    t.integer  "assigned_test_id"
  end

  create_table "try_task_contents", force: :cascade do |t|
    t.integer  "task_result_id"
    t.integer  "task_content_version_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "try_task_contents", ["task_result_id"], name: "index_try_task_contents_on_task_result_id", using: :btree

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
    t.integer  "answer_version_id"
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
    t.integer  "association_version_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "second_name"
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
    t.date     "birthday"
    t.string   "drcode"
    t.string   "token"
    t.datetime "token_expire_at"
    t.string   "priority_role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["token"], name: "index_users_on_token", unique: true, using: :btree

  create_table "version_associations", force: :cascade do |t|
    t.integer "version_id"
    t.string  "foreign_key_name", null: false
    t.integer "foreign_key_id"
  end

  add_index "version_associations", ["foreign_key_name", "foreign_key_id"], name: "index_version_associations_on_foreign_key", using: :btree
  add_index "version_associations", ["version_id"], name: "index_version_associations_on_version_id", using: :btree

  create_table "versions", force: :cascade do |t|
    t.string   "item_type",       null: false
    t.integer  "item_id",         null: false
    t.string   "event",           null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
    t.string   "request_uuid"
    t.string   "controller_name"
    t.string   "action_name"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
