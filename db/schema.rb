# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2025_12_31_200243) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "mac_guffins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.integer "visibility"
    t.index ["user_id"], name: "index_mac_guffins_on_user_id"
  end

  create_table "passwordless_sessions", force: :cascade do |t|
    t.integer "authenticatable_id"
    t.string "authenticatable_type"
    t.datetime "claimed_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "expires_at", precision: nil, null: false
    t.string "identifier", null: false
    t.datetime "timeout_at", precision: nil, null: false
    t.string "token_digest", null: false
    t.datetime "updated_at", null: false
    t.index ["authenticatable_type", "authenticatable_id"], name: "authenticatable"
    t.index ["identifier"], name: "index_passwordless_sessions_on_identifier", unique: true
  end

  create_table "super_admin_audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.json "changes_snapshot", default: {}, null: false
    t.json "context", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "performed_at", null: false
    t.string "resource_id"
    t.string "resource_type", null: false
    t.datetime "updated_at", null: false
    t.string "user_email"
    t.bigint "user_id"
    t.index ["action"], name: "index_super_admin_audit_logs_on_action"
    t.index ["performed_at"], name: "index_super_admin_audit_logs_on_performed_at"
    t.index ["resource_type", "resource_id"], name: "index_super_admin_audit_logs_on_resource_type_and_resource_id"
    t.index ["user_id"], name: "index_super_admin_audit_logs_on_user_id"
  end

  create_table "super_admin_csv_exports", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "direction"
    t.string "error_message"
    t.datetime "expires_at"
    t.json "filters", default: {}, null: false
    t.string "model_class_name", null: false
    t.integer "records_count"
    t.string "resource_name", null: false
    t.string "search"
    t.json "selected_attributes", default: [], null: false
    t.string "sort"
    t.datetime "started_at"
    t.string "status", default: "pending", null: false
    t.string "token", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["created_at"], name: "index_super_admin_csv_exports_on_created_at"
    t.index ["expires_at"], name: "index_super_admin_csv_exports_on_expires_at"
    t.index ["resource_name"], name: "index_super_admin_csv_exports_on_resource_name"
    t.index ["status"], name: "index_super_admin_csv_exports_on_status"
    t.index ["token"], name: "index_super_admin_csv_exports_on_token", unique: true
    t.index ["user_id"], name: "index_super_admin_csv_exports_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.datetime "email_confirmed_at"
    t.datetime "last_login_at"
    t.inet "last_login_ip"
    t.integer "login_count", default: 0, null: false
    t.integer "role", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["email_confirmed_at"], name: "index_users_on_email_confirmed_at"
    t.index ["last_login_at"], name: "index_users_on_last_login_at"
    t.index ["role"], name: "index_users_on_role"
  end

  add_foreign_key "mac_guffins", "users"
end
