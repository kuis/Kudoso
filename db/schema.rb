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

ActiveRecord::Schema.define(version: 20150316181250) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.integer  "member_id"
    t.integer  "created_by_id"
    t.integer  "family_activity_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "device_id"
    t.integer  "content_id"
    t.integer  "allowed_time"
    t.integer  "activity_type_id"
    t.integer  "cost"
    t.integer  "reward"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["family_activity_id"], name: "index_activities_on_family_activity_id", using: :btree
  add_index "activities", ["member_id"], name: "index_activities_on_member_id", using: :btree

  create_table "activity_details", force: true do |t|
    t.integer  "activity_id"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_templates", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "rec_min_age"
    t.integer  "rec_max_age"
    t.integer  "cost",             default: 0
    t.integer  "reward",           default: 0
    t.integer  "time_block"
    t.integer  "activity_type_id"
    t.boolean  "restricted",       default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_templates_device_types", id: false, force: true do |t|
    t.integer "activity_template_id"
    t.integer "device_type_id"
  end

  add_index "activity_templates_device_types", ["activity_template_id", "device_type_id"], name: "activity_templates_device_types_index", unique: true, using: :btree

  create_table "activity_types", force: true do |t|
    t.string   "name"
    t.text     "metadata_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "address_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_devices", force: true do |t|
    t.string   "device_token"
    t.string   "name"
    t.date     "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_keys", force: true do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "member_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contact_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "address1"
    t.string   "address2"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.integer  "address_type_id"
    t.string   "phone"
    t.integer  "phone_type_id"
    t.datetime "last_contact"
    t.boolean  "do_not_call"
    t.boolean  "do_not_email"
    t.integer  "contact_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_descriptors", force: true do |t|
    t.string   "tag"
    t.string   "short"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_ratings", force: true do |t|
    t.string   "org"
    t.string   "tag"
    t.string   "short"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: true do |t|
    t.integer  "content_type_id"
    t.string   "title"
    t.string   "year"
    t.integer  "content_rating_id"
    t.date     "release_date"
    t.string   "language"
    t.text     "description"
    t.string   "length"
    t.text     "metadata"
    t.text     "references"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contents", ["content_rating_id"], name: "index_contents_on_content_rating_id", using: :btree
  add_index "contents", ["content_type_id"], name: "index_contents_on_content_type_id", using: :btree

  create_table "device_types", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "os"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "device_types_family_activities", id: false, force: true do |t|
    t.integer "device_type_id"
    t.integer "family_activity_id"
  end

  add_index "device_types_family_activities", ["device_type_id", "family_activity_id"], name: "device_types_family_activities_index", unique: true, using: :btree

  create_table "devices", force: true do |t|
    t.string   "name"
    t.integer  "device_type_id"
    t.integer  "family_id"
    t.boolean  "managed",               default: false
    t.integer  "management_id"
    t.integer  "primary_member_id"
    t.integer  "current_activity_id"
    t.integer  "managed_devices_count", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "uuid"
  end

  add_index "devices", ["device_type_id"], name: "index_devices_on_device_type_id", using: :btree
  add_index "devices", ["family_id"], name: "index_devices_on_family_id", using: :btree

  create_table "emails", force: true do |t|
    t.integer  "contact_id"
    t.string   "address"
    t.boolean  "is_primary", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contact_id"], name: "index_emails_on_contact_id", using: :btree

  create_table "families", force: true do |t|
    t.string   "name"
    t.integer  "primary_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "memorialized_date"
    t.string   "timezone"
  end

  create_table "family_activities", force: true do |t|
    t.integer  "family_id"
    t.integer  "activity_template_id"
    t.string   "name"
    t.string   "description"
    t.integer  "cost",                 default: 0
    t.integer  "reward",               default: 0
    t.integer  "time_block"
    t.boolean  "restricted",           default: false
    t.text     "device_chains"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "family_activities", ["activity_template_id"], name: "index_family_activities_on_activity_template_id", using: :btree
  add_index "family_activities", ["family_id"], name: "index_family_activities_on_family_id", using: :btree

  create_table "members", force: true do |t|
    t.string   "username"
    t.date     "birth_date"
    t.boolean  "parent"
    t.integer  "family_id"
    t.integer  "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kudos",                            default: 0
    t.string   "encrypted_password",   limit: 128, default: "", null: false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "authentication_token"
  end

  add_index "members", ["family_id"], name: "index_members_on_family_id", using: :btree
  add_index "members", ["username", "family_id"], name: "index_members_on_username_and_family_id", unique: true, using: :btree

  create_table "my_todos", force: true do |t|
    t.integer  "todo_schedule_id"
    t.integer  "member_id"
    t.datetime "due_date"
    t.datetime "due_time"
    t.boolean  "complete"
    t.boolean  "verify"
    t.datetime "verified_at"
    t.integer  "verified_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "my_todos", ["member_id"], name: "index_my_todos_on_member_id", using: :btree
  add_index "my_todos", ["todo_schedule_id"], name: "index_my_todos_on_todo_schedule_id", using: :btree

  create_table "note_attachments", force: true do |t|
    t.integer  "note_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: true do |t|
    t.integer  "ticket_id"
    t.integer  "note_type_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phone_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "schedule_rrules", force: true do |t|
    t.integer  "todo_schedule_id"
    t.string   "rrule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedule_rrules", ["todo_schedule_id"], name: "index_schedule_rrules_on_todo_schedule_id", using: :btree

  create_table "screen_time_schedule_rrules", force: true do |t|
    t.integer  "screen_time_schedule_id"
    t.string   "rrule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "screen_time_schedule_rrules", ["screen_time_schedule_id"], name: "index_screen_time_schedule_rrules_on_screen_time_schedule_id", using: :btree

  create_table "screen_time_schedules", force: true do |t|
    t.integer  "family_id"
    t.integer  "member_id"
    t.integer  "start_seconds"
    t.integer  "end_seconds"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screen_times", force: true do |t|
    t.integer  "member_id"
    t.integer  "dow"
    t.integer  "default_time"
    t.integer  "max_time"
    t.text     "restrictions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "screen_times", ["member_id", "dow"], name: "index_screen_times_on_member_id_and_dow", using: :btree
  add_index "screen_times", ["member_id"], name: "index_screen_times_on_member_id", using: :btree

  create_table "st_overrides", force: true do |t|
    t.integer  "member_id"
    t.integer  "created_by_id"
    t.integer  "time"
    t.datetime "date"
    t.string   "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "st_overrides", ["member_id", "date"], name: "index_st_overrides_on_member_id_and_date", using: :btree
  add_index "st_overrides", ["member_id"], name: "index_st_overrides_on_member_id", using: :btree

  create_table "ticket_types", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: true do |t|
    t.integer  "assigned_to_id"
    t.integer  "user_id"
    t.integer  "contact_id"
    t.integer  "ticket_type_id"
    t.datetime "date_openned"
    t.datetime "date_closed"
    t.string   "status"
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
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean  "active"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "todo_schedules", ["member_id"], name: "index_todo_schedules_on_member_id", using: :btree
  add_index "todo_schedules", ["todo_id"], name: "index_todo_schedules_on_todo_id", using: :btree

  create_table "todo_templates", force: true do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "required"
    t.string   "schedule"
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kudos",       default: 0
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

  add_index "todos", ["family_id"], name: "index_todos_on_family_id", using: :btree
  add_index "todos", ["todo_template_id"], name: "index_todos_on_todo_template_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0,     null: false
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "first_name"
    t.string   "last_name"
    t.boolean  "admin",                  default: false, null: false
    t.integer  "family_id"
    t.integer  "member_id"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
