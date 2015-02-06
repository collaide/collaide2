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

ActiveRecord::Schema.define(version: 20150204000000) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activity_activities", force: :cascade do |t|
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.integer  "owner_id"
    t.string   "owner_type"
    t.string   "key"
    t.boolean  "public",         default: false
    t.text     "parameters"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_activities", ["owner_type", "owner_id"], name: "index_activity_activities_on_owner_type_and_owner_id", using: :btree
  add_index "activity_activities", ["recipient_type", "recipient_id"], name: "index_activity_activities_on_recipient_type_and_recipient_id", using: :btree
  add_index "activity_activities", ["trackable_type", "trackable_id"], name: "index_activity_activities_on_trackable_type_and_trackable_id", using: :btree

  create_table "activity_parameters", force: :cascade do |t|
    t.integer  "owner_id"
    t.string   "owner_type"
    t.datetime "starting_at"
    t.datetime "ending_at"
    t.integer  "trackable_id"
    t.string   "trackable_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activity_parameters", ["owner_type", "owner_id"], name: "index_activity_parameters_on_owner_type_and_owner_id", using: :btree
  add_index "activity_parameters", ["trackable_type", "trackable_id"], name: "index_activity_parameters_on_trackable_type_and_trackable_id", using: :btree

  create_table "group_comment_views", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "comment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_comments", force: :cascade do |t|
    t.text     "message"
    t.boolean  "deleted",    default: false
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "group_email_invitations", force: :cascade do |t|
    t.string  "email"
    t.text    "message"
    t.string  "secret_token"
    t.string  "status"
    t.integer "group_id"
    t.integer "user_id"
  end

  create_table "group_group_creations", force: :cascade do |t|
    t.integer "group_id"
    t.string  "email"
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
    t.string   "steps"
    t.boolean  "finished",               default: false
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

  create_table "group_topics", force: :cascade do |t|
    t.string   "title"
    t.text     "message"
    t.integer  "views",      default: 0
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", force: :cascade do |t|
    t.string   "class_name"
    t.string   "method_name"
    t.text     "values"
    t.boolean  "is_viewed",   default: false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "notifications", ["user_id"], name: "index_notifications_on_user_id", using: :btree

  create_table "rm_repo_items", force: :cascade do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.integer "sender_id"
    t.string  "sender_type"
    t.string  "ancestry"
    t.integer "ancestry_depth", default: 0
    t.string  "name"
    t.float   "file_size"
    t.string  "content_type"
    t.string  "file"
    t.string  "type"
    t.string  "checksum"
  end

  add_index "rm_repo_items", ["ancestry"], name: "index_rm_repo_items_on_ancestry", using: :btree
  add_index "rm_repo_items", ["owner_type", "owner_id"], name: "index_rm_repo_items_on_owner_type_and_owner_id", using: :btree
  add_index "rm_repo_items", ["sender_type", "sender_id"], name: "index_rm_repo_items_on_sender_type_and_sender_id", using: :btree

  create_table "rm_sharings", force: :cascade do |t|
    t.integer "owner_id"
    t.string  "owner_type"
    t.integer "creator_id"
    t.string  "creator_type"
    t.integer "repo_item_id"
    t.boolean "can_create",   default: false
    t.boolean "can_read",     default: false
    t.boolean "can_update",   default: false
    t.boolean "can_delete",   default: false
    t.boolean "can_share",    default: false
  end

  add_index "rm_sharings", ["creator_type", "creator_id"], name: "index_rm_sharings_on_creator_type_and_creator_id", using: :btree
  add_index "rm_sharings", ["owner_type", "owner_id"], name: "index_rm_sharings_on_owner_type_and_owner_id", using: :btree
  add_index "rm_sharings", ["repo_item_id"], name: "index_rm_sharings_on_repo_item_id", using: :btree

  create_table "rm_sharings_members", force: :cascade do |t|
    t.integer "sharing_id"
    t.integer "member_id"
    t.string  "member_type"
    t.boolean "can_add",     default: false
    t.boolean "can_remove",  default: false
  end

  add_index "rm_sharings_members", ["member_type", "member_id"], name: "index_rm_sharings_members_on_member_type_and_member_id", using: :btree
  add_index "rm_sharings_members", ["sharing_id"], name: "index_rm_sharings_members_on_sharing_id", using: :btree

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
