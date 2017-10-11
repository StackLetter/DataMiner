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

ActiveRecord::Schema.define(version: 20171008144548) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "external_id"
    t.string "email"
    t.string "frequency"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answer_tags", force: :cascade do |t|
    t.bigint "answer_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_answer_tags_on_answer_id"
    t.index ["tag_id"], name: "index_answer_tags_on_tag_id"
  end

  create_table "answers", force: :cascade do |t|
    t.integer "external_id"
    t.integer "site_id"
    t.integer "up_vote_count"
    t.integer "down_vote_count"
    t.integer "owner_id"
    t.integer "question_id"
    t.integer "score"
    t.date "creation_date"
    t.date "community_owned_date"
    t.date "last_activity_date"
    t.date "locked_date"
    t.text "body"
    t.boolean "is_accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_answers_on_external_id"
    t.index ["site_id"], name: "index_answers_on_site_id"
  end

  create_table "badges", force: :cascade do |t|
    t.integer "external_id"
    t.integer "site_id"
    t.integer "award_count"
    t.boolean "user_profiled", default: false
    t.string "badge_type"
    t.string "rank"
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_badges_on_external_id"
    t.index ["site_id"], name: "index_badges_on_site_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "external_id"
    t.integer "site_id"
    t.integer "answer_id"
    t.integer "question_id"
    t.integer "owner_id"
    t.integer "score"
    t.date "creation_date"
    t.text "body"
    t.string "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["answer_id"], name: "index_comments_on_answer_id"
    t.index ["external_id"], name: "index_comments_on_external_id"
    t.index ["question_id"], name: "index_comments_on_question_id"
    t.index ["site_id"], name: "index_comments_on_site_id"
  end

  create_table "question_tags", force: :cascade do |t|
    t.bigint "question_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_tags_on_question_id"
    t.index ["tag_id"], name: "index_question_tags_on_tag_id"
  end

  create_table "questions", force: :cascade do |t|
    t.integer "accepted_answer_id"
    t.integer "bounty_amount"
    t.integer "external_id"
    t.integer "site_id"
    t.integer "owner_id"
    t.integer "score"
    t.integer "up_vote_count"
    t.integer "down_vote_count"
    t.integer "view_count"
    t.date "bounty_closes_date"
    t.date "closed_date"
    t.date "creation_date"
    t.date "community_owned_date"
    t.date "last_activity_date"
    t.date "locked_date"
    t.text "body"
    t.string "title"
    t.boolean "is_answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_questions_on_external_id"
    t.index ["site_id"], name: "index_questions_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "api"
    t.boolean "enabled"
    t.string "name"
    t.integer "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "site_id"
    t.integer "external_id"
    t.boolean "has_synonyms"
    t.boolean "is_moderator_only"
    t.boolean "is_required"
    t.boolean "user_profiled", default: false
    t.string "synonyms", default: [], array: true
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_tags_on_external_id"
    t.index ["site_id"], name: "index_tags_on_site_id"
  end

  create_table "user_badges", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "badge_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["badge_id"], name: "index_user_badges_on_badge_id"
    t.index ["user_id"], name: "index_user_badges_on_user_id"
  end

  create_table "user_tags", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "tag_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_user_tags_on_tag_id"
    t.index ["user_id"], name: "index_user_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.integer "external_id"
    t.integer "account_id"
    t.integer "site_id"
    t.integer "age"
    t.integer "reputation"
    t.integer "accept_rate"
    t.integer "reputation_change_month"
    t.integer "reputation_change_year"
    t.integer "reputation_change_week"
    t.date "creation_date"
    t.date "last_access_date"
    t.string "display_name"
    t.string "user_type"
    t.string "website_url"
    t.string "location"
    t.boolean "is_employee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_users_on_external_id"
    t.index ["id"], name: "index_users_on_id"
  end

  add_foreign_key "answer_tags", "answers"
  add_foreign_key "answer_tags", "tags"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "owner_id"
  add_foreign_key "comments", "users", column: "owner_id"
  add_foreign_key "question_tags", "questions"
  add_foreign_key "question_tags", "tags"
  add_foreign_key "questions", "users", column: "owner_id"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "users", "sites"
end
