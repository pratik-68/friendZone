# frozen_string_literal: true

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

ActiveRecord::Schema.define(version: 20_200_402_095_837) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'active_storage_attachments', force: :cascade do |t|
    t.string 'name', null: false
    t.string 'record_type', null: false
    t.bigint 'record_id', null: false
    t.bigint 'blob_id', null: false
    t.datetime 'created_at', null: false
    t.index ['blob_id'], name: 'index_active_storage_attachments_on_blob_id'
    t.index %w[record_type record_id name blob_id], name: 'index_active_storage_attachments_uniqueness', unique: true
  end

  create_table 'active_storage_blobs', force: :cascade do |t|
    t.string 'key', null: false
    t.string 'filename', null: false
    t.string 'content_type'
    t.text 'metadata'
    t.bigint 'byte_size', null: false
    t.string 'checksum', null: false
    t.datetime 'created_at', null: false
    t.index ['key'], name: 'index_active_storage_blobs_on_key', unique: true
  end

  create_table 'friends', force: :cascade do |t|
    t.bigint 'user1_id'
    t.bigint 'user2_id'
    t.bigint 'requester_id'
    t.string 'verification_token', null: false
    t.datetime 'verification_sent_at'
    t.integer 'status', default: 0, null: false
    t.datetime 'accepted_at'
    t.integer 'notifications', default: 0, null: false
    t.index ['requester_id'], name: 'index_friends_on_requester_id'
    t.index %w[user1_id user2_id], name: 'index_friends_on_user1_id_and_user2_id', unique: true
    t.index ['user1_id'], name: 'index_friends_on_user1_id'
    t.index ['user2_id'], name: 'index_friends_on_user2_id'
    t.index ['verification_token'], name: 'index_friends_on_verification_token', unique: true
  end

  create_table 'login_tokens', force: :cascade do |t|
    t.string 'token', null: false
    t.datetime 'last_used_on', null: false
    t.datetime 'created_at', null: false
    t.bigint 'user_id'
    t.index ['token'], name: 'index_login_tokens_on_token', unique: true
    t.index ['user_id'], name: 'index_login_tokens_on_user_id'
  end

  create_table 'post_users', force: :cascade do |t|
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'user_id'
    t.bigint 'post_id'
    t.index ['post_id'], name: 'index_post_users_on_post_id'
    t.index %w[user_id post_id], name: 'index_post_users_on_user_id_and_post_id', unique: true
    t.index ['user_id'], name: 'index_post_users_on_user_id'
  end

  create_table 'posts', force: :cascade do |t|
    t.bigint 'user_id'
    t.integer 'visible_to', null: false
    t.text 'description'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_posts_on_user_id'
  end

  create_table 'users', force: :cascade do |t|
    t.string 'first_name', limit: 20, null: false
    t.string 'last_name', limit: 20, null: false
    t.integer 'gender', null: false
    t.date 'date_of_birth', null: false
    t.string 'city', limit: 20
    t.text 'interests'
    t.string 'email', null: false
    t.string 'username', limit: 20, null: false
    t.string 'password_digest', null: false
    t.string 'email_verification_token', null: false
    t.boolean 'is_verified', default: false, null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'last_login_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['email_verification_token'], name: 'index_users_on_email_verification_token', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['username'], name: 'index_users_on_username', unique: true
  end

  add_foreign_key 'active_storage_attachments', 'active_storage_blobs', column: 'blob_id'
  add_foreign_key 'friends', 'users', column: 'requester_id'
  add_foreign_key 'friends', 'users', column: 'user1_id'
  add_foreign_key 'friends', 'users', column: 'user2_id'
  add_foreign_key 'login_tokens', 'users'
  add_foreign_key 'post_users', 'posts'
  add_foreign_key 'post_users', 'users'
  add_foreign_key 'posts', 'users'
end
