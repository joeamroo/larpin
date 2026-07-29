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

ActiveRecord::Schema[8.1].define(version: 2026_07_29_021729) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "articles", force: :cascade do |t|
    t.text "body"
    t.datetime "created_at", null: false
    t.string "headline", null: false
    t.integer "persona_id", null: false
    t.integer "readers_seed", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_articles_on_created_at"
    t.index ["persona_id"], name: "index_articles_on_persona_id"
  end

  create_table "comment_likes", force: :cascade do |t|
    t.integer "comment_id", null: false
    t.datetime "created_at", null: false
    t.integer "persona_id", null: false
    t.datetime "updated_at", null: false
    t.index ["comment_id", "persona_id"], name: "index_comment_likes_on_comment_id_and_persona_id", unique: true
    t.index ["comment_id"], name: "index_comment_likes_on_comment_id"
    t.index ["persona_id"], name: "index_comment_likes_on_persona_id"
  end

  create_table "comments", force: :cascade do |t|
    t.text "body", null: false
    t.datetime "created_at", null: false
    t.integer "likes_count", default: 0, null: false
    t.integer "persona_id", null: false
    t.integer "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_comments_on_persona_id"
    t.index ["post_id"], name: "index_comments_on_post_id"
  end

  create_table "connections", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "receiver_id", null: false
    t.integer "requester_id", null: false
    t.string "status", default: "pending", null: false
    t.datetime "updated_at", null: false
    t.index ["receiver_id"], name: "index_connections_on_receiver_id"
    t.index ["requester_id", "receiver_id"], name: "index_connections_on_requester_id_and_receiver_id", unique: true
    t.index ["requester_id"], name: "index_connections_on_requester_id"
  end

  create_table "conversations", force: :cascade do |t|
    t.integer "a_id", null: false
    t.integer "b_id", null: false
    t.datetime "created_at", null: false
    t.datetime "last_message_at"
    t.datetime "updated_at", null: false
    t.index ["a_id", "b_id"], name: "index_conversations_on_a_id_and_b_id", unique: true
    t.index ["a_id"], name: "index_conversations_on_a_id"
    t.index ["b_id"], name: "index_conversations_on_b_id"
  end

  create_table "endorsements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "endorser_id", null: false
    t.integer "persona_id", null: false
    t.string "skill", null: false
    t.datetime "updated_at", null: false
    t.index ["endorser_id"], name: "index_endorsements_on_endorser_id"
    t.index ["persona_id", "endorser_id", "skill"], name: "idx_endorsements_unique", unique: true
    t.index ["persona_id"], name: "index_endorsements_on_persona_id"
  end

  create_table "experiences", force: :cascade do |t|
    t.string "company", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "end_year"
    t.integer "persona_id", null: false
    t.integer "start_year", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_experiences_on_persona_id"
  end

  create_table "job_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "job_id", null: false
    t.integer "persona_id", null: false
    t.datetime "updated_at", null: false
    t.index ["job_id", "persona_id"], name: "index_job_applications_on_job_id_and_persona_id", unique: true
    t.index ["job_id"], name: "index_job_applications_on_job_id"
    t.index ["persona_id"], name: "index_job_applications_on_persona_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.integer "applications_count", default: 0, null: false
    t.string "comp"
    t.string "company", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.string "location"
    t.integer "persona_id", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_jobs_on_persona_id"
  end

  create_table "messages", force: :cascade do |t|
    t.text "body", null: false
    t.integer "conversation_id", null: false
    t.datetime "created_at", null: false
    t.boolean "read", default: false, null: false
    t.integer "sender_id", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id", "created_at"], name: "index_messages_on_conversation_id_and_created_at"
    t.index ["conversation_id"], name: "index_messages_on_conversation_id"
    t.index ["sender_id"], name: "index_messages_on_sender_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "actor_id"
    t.string "body", null: false
    t.datetime "created_at", null: false
    t.integer "persona_id", null: false
    t.boolean "read", default: false, null: false
    t.datetime "updated_at", null: false
    t.string "url"
    t.index ["actor_id"], name: "index_notifications_on_actor_id"
    t.index ["persona_id", "read"], name: "index_notifications_on_persona_id_and_read"
    t.index ["persona_id"], name: "index_notifications_on_persona_id"
  end

  create_table "personas", force: :cascade do |t|
    t.integer "base_clout", default: 0, null: false
    t.text "bio"
    t.datetime "created_at", null: false
    t.string "device_token"
    t.string "headline", null: false
    t.integer "hue", default: 210, null: false
    t.boolean "is_bot", default: false, null: false
    t.date "larping_since", null: false
    t.string "name", null: false
    t.integer "posts_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["device_token"], name: "index_personas_on_device_token", unique: true
  end

  create_table "posts", force: :cascade do |t|
    t.text "body", default: "", null: false
    t.integer "comments_count", default: 0, null: false
    t.datetime "created_at", null: false
    t.integer "impressions_seed", default: 0, null: false
    t.string "kind", default: "post", null: false
    t.integer "persona_id", null: false
    t.integer "reactions_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["kind"], name: "index_posts_on_kind"
    t.index ["persona_id"], name: "index_posts_on_persona_id"
  end

  create_table "profile_skills", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.integer "persona_id", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id", "name"], name: "index_profile_skills_on_persona_id_and_name", unique: true
    t.index ["persona_id"], name: "index_profile_skills_on_persona_id"
  end

  create_table "reactions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "kind", null: false
    t.integer "persona_id", null: false
    t.integer "post_id", null: false
    t.datetime "updated_at", null: false
    t.index ["persona_id"], name: "index_reactions_on_persona_id"
    t.index ["post_id", "persona_id"], name: "index_reactions_on_post_id_and_persona_id", unique: true
    t.index ["post_id"], name: "index_reactions_on_post_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "articles", "personas"
  add_foreign_key "comment_likes", "comments"
  add_foreign_key "comment_likes", "personas"
  add_foreign_key "comments", "personas"
  add_foreign_key "comments", "posts"
  add_foreign_key "connections", "personas", column: "receiver_id"
  add_foreign_key "connections", "personas", column: "requester_id"
  add_foreign_key "conversations", "personas", column: "a_id"
  add_foreign_key "conversations", "personas", column: "b_id"
  add_foreign_key "endorsements", "personas"
  add_foreign_key "endorsements", "personas", column: "endorser_id"
  add_foreign_key "experiences", "personas"
  add_foreign_key "job_applications", "jobs"
  add_foreign_key "job_applications", "personas"
  add_foreign_key "jobs", "personas"
  add_foreign_key "messages", "conversations"
  add_foreign_key "messages", "personas", column: "sender_id"
  add_foreign_key "notifications", "personas"
  add_foreign_key "notifications", "personas", column: "actor_id"
  add_foreign_key "posts", "personas"
  add_foreign_key "profile_skills", "personas"
  add_foreign_key "reactions", "personas"
  add_foreign_key "reactions", "posts"
end
