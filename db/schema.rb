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

ActiveRecord::Schema.define(version: 20141231163455) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "families", force: true do |t|
    t.string   "name"
    t.integer  "primary_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "memorialized_date"
  end

  create_table "members", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "password"
    t.date     "birth_date"
    t.boolean  "parent"
    t.integer  "family_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kudos"
  end

  create_table "my_todos", force: true do |t|
    t.integer  "todo_schedule_id"
    t.integer  "member_id"
    t.date     "due_date"
    t.datetime "due_time"
    t.boolean  "complete"
    t.boolean  "verify"
    t.datetime "verified_at"
    t.integer  "verified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_rrules", force: true do |t|
    t.integer  "todo_schedule_id"
    t.string   "rrule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_groups", force: true do |t|
    t.string   "name"
    t.integer  "rec_min_age"
    t.integer  "rec_max_age"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_groups_todo_templates", id: false, force: true do |t|
    t.integer "todo_group_id"
    t.integer "todo_template_id"
  end

  add_index "todo_groups_todo_templates", ["todo_group_id", "todo_template_id"], name: "todo_group_template_habtm_idx", using: :btree
  add_index "todo_groups_todo_templates", ["todo_template_id"], name: "index_todo_groups_todo_templates_on_todo_template_id", using: :btree

  create_table "todo_schedules", force: true do |t|
    t.integer  "todo_id"
    t.integer  "member_id"
    t.date     "start_date"
    t.date     "end_date"
    t.boolean  "active"
    t.text     "schedule"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "todo_templates", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "required"
    t.string   "schedule"
    t.string   "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kudos"
  end

  create_table "todos", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "required"
    t.integer  "kudos"
    t.integer  "todo_template_id"
    t.integer  "family_id"
    t.boolean  "active"
    t.text     "schedule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
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
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,  null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin"
    t.integer  "family_id"
    t.integer  "member_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
