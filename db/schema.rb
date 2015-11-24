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

ActiveRecord::Schema.define(version: 20151114173319) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "created_by_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "content_id"
    t.integer  "allowed_time"
    t.integer  "cost"
    t.integer  "reward"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "activity_template_id"
  end

  add_index "activities", ["member_id"], name: "index_activities_on_member_id", using: :btree

  create_table "activities_devices", force: :cascade do |t|
    t.integer "activity_id", null: false
    t.integer "device_id",   null: false
  end

  add_index "activities_devices", ["activity_id", "device_id"], name: "index_activities_devices_on_activity_id_and_device_id", using: :btree
  add_index "activities_devices", ["device_id", "activity_id"], name: "index_activities_devices_on_device_id_and_activity_id", using: :btree

  create_table "activity_details", force: :cascade do |t|
    t.integer  "activity_id"
    t.text     "metadata"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_template_device_types", force: :cascade do |t|
    t.integer  "activity_template_id"
    t.integer  "device_type_id"
    t.string   "type"
    t.string   "launch_url"
    t.string   "app_name"
    t.string   "app_id"
    t.string   "app_store_url"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  create_table "activity_templates", force: :cascade do |t|
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
    t.string   "external_id"
    t.boolean  "disabled"
  end

  create_table "activity_types", force: :cascade do |t|
    t.string   "name"
    t.text     "metadata_fields"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "partner_id"
  end

  create_table "address_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "alerter_messages", force: :cascade do |t|
    t.string   "type"
    t.string   "short_msg",            default: ""
    t.text     "long_msg",             default: ""
    t.boolean  "draft",                default: false
    t.string   "notification_code"
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.integer  "notification_type_id"
    t.string   "attachment"
    t.datetime "updated_at",                           null: false
    t.datetime "created_at",                           null: false
    t.boolean  "global",               default: false
    t.datetime "expires"
  end

  create_table "alerter_notification_types", force: :cascade do |t|
    t.string "name"
  end

  create_table "alerter_preferences", force: :cascade do |t|
    t.integer "notification_type_id"
    t.integer "notifiable_id"
    t.string  "notifiable_type"
    t.text    "alert_methods"
  end

  create_table "alerter_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "message_id",                               null: false
    t.boolean  "is_read",                  default: false
    t.boolean  "deleted",                  default: false
    t.string   "mailbox_type",  limit: 25
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
  end

  add_index "alerter_receipts", ["message_id"], name: "index_alerter_receipts_on_message_id", using: :btree

  create_table "api_devices", force: :cascade do |t|
    t.string   "device_token"
    t.string   "name"
    t.date     "expires_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "api_keys", force: :cascade do |t|
    t.string   "access_token"
    t.datetime "expires_at"
    t.integer  "member_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "app_devices", force: :cascade do |t|
    t.integer  "app_id"
    t.integer  "device_id"
    t.string   "version"
    t.datetime "installed_at"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "app_members", force: :cascade do |t|
    t.integer  "app_id"
    t.integer  "member_id"
    t.boolean  "restricted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "applogs", force: :cascade do |t|
    t.integer  "app_id"
    t.integer  "device_id"
    t.integer  "member_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "applogs", ["app_id"], name: "index_applogs_on_app_id", using: :btree
  add_index "applogs", ["device_id"], name: "index_applogs_on_device_id", using: :btree
  add_index "applogs", ["member_id"], name: "index_applogs_on_member_id", using: :btree

  create_table "apps", force: :cascade do |t|
    t.string   "name"
    t.string   "uuid"
    t.string   "publisher"
    t.string   "url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "avatars", force: :cascade do |t|
    t.string   "name"
    t.string   "gender"
    t.integer  "theme_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
  end

  create_table "commands", force: :cascade do |t|
    t.integer  "device_id"
    t.string   "name"
    t.boolean  "executed"
    t.datetime "sent"
    t.integer  "status"
    t.string   "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contacts", force: :cascade do |t|
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

  create_table "content_descriptors", force: :cascade do |t|
    t.string   "tag"
    t.string   "short"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_ratings", force: :cascade do |t|
    t.string   "org"
    t.string   "tag"
    t.string   "short"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "content_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", force: :cascade do |t|
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

  create_table "device_categories", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "device_types", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "os"
    t.string   "version"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "device_category_id"
    t.string   "icon_file_name"
    t.string   "icon_content_type"
    t.integer  "icon_file_size"
    t.datetime "icon_updated_at"
  end

  create_table "device_types_family_activities", id: false, force: :cascade do |t|
    t.integer "device_type_id"
    t.integer "family_activity_id"
  end

  add_index "device_types_family_activities", ["device_type_id", "family_activity_id"], name: "device_types_family_activities_index", unique: true, using: :btree

  create_table "devices", force: :cascade do |t|
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
    t.string   "udid"
    t.string   "wifi_mac"
    t.datetime "last_contact"
    t.string   "os_version"
    t.string   "build_version"
    t.string   "product_name"
    t.string   "mobicip_device_id"
    t.string   "device_name"
    t.string   "last_ip"
    t.string   "mac_address"
    t.integer  "router_id"
    t.string   "secure_key"
  end

  add_index "devices", ["device_type_id"], name: "index_devices_on_device_type_id", using: :btree
  add_index "devices", ["family_id"], name: "index_devices_on_family_id", using: :btree

  create_table "emails", force: :cascade do |t|
    t.integer  "contact_id"
    t.string   "address"
    t.boolean  "is_primary", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "emails", ["contact_id"], name: "index_emails_on_contact_id", using: :btree

  create_table "families", force: :cascade do |t|
    t.string   "name"
    t.integer  "primary_contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "memorialized_date"
    t.string   "timezone"
    t.integer  "default_screen_time", default: 7200
    t.string   "default_filter",      default: "monitor"
    t.string   "mobicip_password"
    t.string   "mobicip_id"
    t.string   "mobicip_token"
    t.string   "secure_key"
  end

  create_table "family_activity_preferences", force: :cascade do |t|
    t.integer  "activity_template_id"
    t.integer  "family_id"
    t.integer  "cost"
    t.integer  "reward"
    t.integer  "time_block"
    t.boolean  "preferred"
    t.boolean  "restricted"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "family_activity_preferences", ["activity_template_id"], name: "index_family_activity_preferences_on_activity_template_id", using: :btree
  add_index "family_activity_preferences", ["family_id"], name: "index_family_activity_preferences_on_family_id", using: :btree

  create_table "family_device_categories", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "device_category_id"
    t.integer  "amount",             default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "invoices", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "closed_on"
    t.text     "description"
    t.integer  "amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "invoices", ["user_id"], name: "index_invoices_on_user_id", using: :btree

  create_table "ledger_entries", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "debit"
    t.integer  "credit"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "ledger_entries", ["member_id"], name: "index_ledger_entries_on_member_id", using: :btree

  create_table "members", force: :cascade do |t|
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
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "mobicip_profile"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "mobicip_filter"
    t.integer  "theme_id"
    t.string   "gender",               limit: 1
  end

  add_index "members", ["family_id"], name: "index_members_on_family_id", using: :btree
  add_index "members", ["username", "family_id"], name: "index_members_on_username_and_family_id", unique: true, using: :btree

  create_table "my_todos", force: :cascade do |t|
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

  create_table "note_attachments", force: :cascade do |t|
    t.integer  "note_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "note_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notes", force: :cascade do |t|
    t.integer  "ticket_id"
    t.integer  "note_type_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "partners", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "api_key"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "invoice_id"
    t.string   "description"
    t.integer  "amount"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "payments", ["invoice_id"], name: "index_payments_on_invoice_id", using: :btree

  create_table "phone_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plugs", force: :cascade do |t|
    t.string   "mac_address"
    t.string   "serial"
    t.string   "secure_key"
    t.datetime "last_seen"
    t.string   "last_known_ip"
    t.boolean  "registered"
    t.integer  "device_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "router_firmwares", force: :cascade do |t|
    t.integer  "router_model_id"
    t.string   "version"
    t.text     "notes"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "checksum"
    t.string   "firmware_file_name"
    t.string   "firmware_content_type"
    t.integer  "firmware_file_size"
    t.datetime "firmware_updated_at"
    t.string   "firmware_fingerprint"
  end

  create_table "router_models", force: :cascade do |t|
    t.string   "name"
    t.string   "num"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "routers", force: :cascade do |t|
    t.integer  "router_model_id"
    t.integer  "router_firmware_id"
    t.integer  "family_id"
    t.string   "last_known_ip"
    t.datetime "last_seen"
    t.datetime "last_firmware_update"
    t.string   "mac_address"
    t.string   "secure_key"
    t.boolean  "registered"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
  end

  add_index "routers", ["mac_address"], name: "index_routers_on_mac_address", using: :btree

  create_table "schedule_rrules", force: :cascade do |t|
    t.integer  "todo_schedule_id"
    t.string   "rrule"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "schedule_rrules", ["todo_schedule_id"], name: "index_schedule_rrules_on_todo_schedule_id", using: :btree

  create_table "screen_time_schedules", force: :cascade do |t|
    t.integer  "family_id"
    t.integer  "member_id"
    t.text     "restrictions"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "screen_times", force: :cascade do |t|
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

  create_table "st_overrides", force: :cascade do |t|
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

  create_table "steps", force: :cascade do |t|
    t.integer  "stepable_id"
    t.string   "stepable_type"
    t.text     "steps"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "steps", ["stepable_type", "stepable_id"], name: "index_steps_on_stepable_type_and_stepable_id", using: :btree

  create_table "themes", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "json"
  end

  create_table "ticket_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tickets", force: :cascade do |t|
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

  create_table "todo_groups_todo_templates", id: false, force: :cascade do |t|
    t.integer "todo_group_id"
    t.integer "todo_template_id"
  end

  add_index "todo_groups_todo_templates", ["todo_group_id", "todo_template_id"], name: "todo_group_template_habtm_idx", using: :btree
  add_index "todo_groups_todo_templates", ["todo_template_id"], name: "index_todo_groups_todo_templates_on_todo_template_id", using: :btree

  create_table "todo_schedules", force: :cascade do |t|
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

  create_table "todo_templates", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.boolean  "required"
    t.string   "schedule"
    t.boolean  "disabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kudos",       default: 0
    t.integer  "rec_min_age"
    t.integer  "rec_max_age"
    t.integer  "def_min_age"
    t.integer  "def_max_age"
  end

  create_table "todos", force: :cascade do |t|
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

  create_table "users", force: :cascade do |t|
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
    t.integer  "wizard_step",            default: 1
    t.boolean  "is_account_current"
    t.string   "stripe_customer_id"
    t.date     "plan_expiration"
    t.string   "plan"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  add_foreign_key "alerter_receipts", "alerter_messages", column: "message_id", name: "receipts_on_message_id"
  add_foreign_key "applogs", "apps"
  add_foreign_key "applogs", "devices"
  add_foreign_key "applogs", "members"
  add_foreign_key "family_activity_preferences", "activity_templates"
  add_foreign_key "family_activity_preferences", "families"
  add_foreign_key "invoices", "users"
  add_foreign_key "ledger_entries", "members"
  add_foreign_key "payments", "invoices"
end
