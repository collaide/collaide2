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

ActiveRecord::Schema.define(version: 20150120151556) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "group_email_invitations", force: :cascade do |t|
    t.string  "email"
    t.text    "message"
    t.string  "secret_token"
    t.string  "status"
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "group_group_members", force: :cascade do |t|
    t.integer  "group_id"
    t.integer  "user_id"
    t.string   "role"
    t.string   "joined_method"
    t.integer  "invited_or_added_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_group_members", ["group_id"], name: "index_group_group_members_on_group_id", using: :btree
  add_index "group_group_members", ["invited_or_added_by_id"], name: "index_group_group_members_on_invited_or_added_by_id", using: :btree
  add_index "group_group_members", ["user_id"], name: "index_group_group_members_on_user_id", using: :btree

  create_table "group_groups", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "can_index_activity"
    t.string   "can_delete_group"
    t.string   "can_read_topic"
    t.string   "can_index_members"
    t.string   "can_read_member"
    t.string   "can_delete_member"
    t.string   "can_write_file"
    t.string   "can_index_files"
    t.string   "can_read_file"
    t.string   "can_delete_file"
    t.string   "can_index_topics"
    t.string   "can_write_topic"
    t.string   "can_delete_topic"
    t.string   "can_create_invitation"
    t.string   "can_manage_invitations"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_invitations", force: :cascade do |t|
    t.text     "message"
    t.string   "status"
    t.integer  "sender_id"
    t.integer  "group_id"
    t.integer  "receiver_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "group_invitations", ["group_id"], name: "index_group_invitations_on_group_id", using: :btree
  add_index "group_invitations", ["receiver_id"], name: "index_group_invitations_on_receiver_id", using: :btree
  add_index "group_invitations", ["sender_id"], name: "index_group_invitations_on_sender_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "name"
    t.string   "role"
    t.string   "avatar"
    t.integer  "points",                 default: 5
    t.boolean  "has_notifications",      default: false
    t.string   "provider"
    t.string   "uid"
    t.string   "old_password"
    t.boolean  "old_user"
    t.integer  "old_id"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "authentication_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", unique: true, using: :btree
  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
