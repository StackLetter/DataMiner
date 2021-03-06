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

ActiveRecord::Schema.define(version: 20180307183352) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer "external_id"
    t.string "email"
    t.string "frequency"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "available_token"
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
    t.datetime "creation_date"
    t.datetime "community_owned_date"
    t.datetime "last_activity_date"
    t.datetime "locked_date"
    t.text "body"
    t.boolean "is_accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "removed"
    t.integer "comment_count"
    t.index ["external_id"], name: "index_answers_on_external_id"
    t.index ["owner_id"], name: "index_answers_on_owner_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
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
    t.datetime "creation_date"
    t.text "body"
    t.string "post_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "removed"
    t.index ["answer_id"], name: "index_comments_on_answer_id"
    t.index ["external_id"], name: "index_comments_on_external_id"
    t.index ["owner_id"], name: "index_comments_on_owner_id"
    t.index ["question_id"], name: "index_comments_on_question_id"
    t.index ["site_id"], name: "index_comments_on_site_id"
  end

  create_table "evaluation_newsletters", force: :cascade do |t|
    t.bigint "newsletter_id", null: false
    t.integer "response_counter"
    t.string "content_type"
    t.string "content_detail"
    t.string "user_response_type"
    t.string "user_response_detail"
    t.string "event_identifier"
    t.datetime "action_datetime"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["newsletter_id"], name: "index_evaluation_newsletters_on_newsletter_id"
  end

  create_table "mls_question_topics", force: :cascade do |t|
    t.integer "question_id"
    t.integer "topic_id"
    t.integer "site_id"
    t.float "weight"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_mls_question_topics_on_question_id"
    t.index ["site_id"], name: "index_mls_question_topics_on_site_id"
    t.index ["topic_id"], name: "index_mls_question_topics_on_topic_id"
  end

  create_table "msa_daily_newsletter_sections", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "sorted_sections", default: [], array: true
    t.integer "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_msa_daily_newsletter_sections_on_segment_id"
  end

  create_table "msa_sections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_endpoint"
    t.string "filter_endpoint"
    t.string "filter_query"
    t.string "content_type"
  end

  create_table "msa_segment_section_reward_histories", force: :cascade do |t|
    t.integer "sections_ids", array: true
    t.float "sections_rewards", array: true
    t.integer "segment_id"
    t.string "newsletter_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "daily_newsletters_count", array: true
    t.integer "weekly_newsletters_count", array: true
    t.index ["segment_id"], name: "index_msa_segment_section_reward_histories_on_segment_id"
  end

  create_table "msa_segment_sections", force: :cascade do |t|
    t.integer "segment_id"
    t.integer "section_id"
    t.float "reward"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "daily_newsletters_count"
    t.integer "weekly_newsletters_count"
    t.index ["section_id"], name: "index_msa_segment_sections_on_section_id"
    t.index ["segment_id"], name: "index_msa_segment_sections_on_segment_id"
  end

  create_table "msa_segments", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "r_identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "msa_user_segment_changes", force: :cascade do |t|
    t.integer "from_r_identifier"
    t.integer "to_r_identifier"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_msa_user_segment_changes_on_user_id"
  end

  create_table "msa_weekly_newsletter_sections", force: :cascade do |t|
    t.datetime "from"
    t.datetime "to"
    t.integer "sorted_sections", default: [], array: true
    t.integer "segment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["segment_id"], name: "index_msa_weekly_newsletter_sections_on_segment_id"
  end

  create_table "newsletter_sections", force: :cascade do |t|
    t.bigint "newsletter_id", null: false
    t.string "name"
    t.string "content_type"
    t.text "description"
    t.integer "content_ids", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "section_id"
    t.index ["newsletter_id"], name: "index_newsletter_sections_on_newsletter_id"
  end

  create_table "newsletters", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_newsletters_on_user_id"
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
    t.datetime "bounty_closes_date"
    t.datetime "closed_date"
    t.datetime "creation_date"
    t.datetime "community_owned_date"
    t.datetime "last_activity_date"
    t.datetime "locked_date"
    t.text "body"
    t.string "title"
    t.boolean "is_answered"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "removed"
    t.integer "accepted_answer_external_id"
    t.integer "comment_count"
    t.index ["accepted_answer_id"], name: "index_questions_on_accepted_answer_id"
    t.index ["external_id"], name: "index_questions_on_external_id"
    t.index ["owner_id"], name: "index_questions_on_owner_id"
    t.index ["site_id"], name: "index_questions_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.string "api"
    t.boolean "enabled"
    t.string "name"
    t.integer "config_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "url"
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

  create_table "user_favorites", force: :cascade do |t|
    t.integer "site_id"
    t.integer "user_id"
    t.integer "external_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["external_id"], name: "index_user_favorites_on_external_id"
    t.index ["site_id"], name: "index_user_favorites_on_site_id"
    t.index ["user_id"], name: "index_user_favorites_on_user_id"
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
    t.datetime "creation_date"
    t.datetime "last_access_date"
    t.string "display_name"
    t.string "user_type"
    t.string "website_url"
    t.string "location"
    t.boolean "is_employee"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "removed"
    t.integer "answers_count"
    t.integer "questions_count"
    t.integer "user_badges_count"
    t.integer "comments_count"
    t.integer "segment_id"
    t.boolean "segment_changed"
    t.index ["account_id"], name: "users_account_id"
    t.index ["external_id"], name: "index_users_on_external_id"
    t.index ["id"], name: "index_users_on_id"
    t.index ["segment_id"], name: "index_users_on_segment_id"
    t.index ["site_id"], name: "index_users_on_site_id"
  end

  add_foreign_key "answer_tags", "answers"
  add_foreign_key "answer_tags", "tags"
  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users", column: "owner_id"
  add_foreign_key "comments", "users", column: "owner_id"
  add_foreign_key "evaluation_newsletters", "newsletters"
  add_foreign_key "mls_question_topics", "questions"
  add_foreign_key "mls_question_topics", "sites"
  add_foreign_key "msa_daily_newsletter_sections", "msa_segments", column: "segment_id"
  add_foreign_key "msa_segment_section_reward_histories", "msa_segments", column: "segment_id"
  add_foreign_key "msa_segment_sections", "msa_sections", column: "section_id"
  add_foreign_key "msa_segment_sections", "msa_segments", column: "segment_id"
  add_foreign_key "msa_user_segment_changes", "users"
  add_foreign_key "msa_weekly_newsletter_sections", "msa_segments", column: "segment_id"
  add_foreign_key "newsletter_sections", "newsletters"
  add_foreign_key "newsletters", "users"
  add_foreign_key "question_tags", "questions"
  add_foreign_key "question_tags", "tags"
  add_foreign_key "questions", "users", column: "owner_id"
  add_foreign_key "user_badges", "badges"
  add_foreign_key "user_badges", "users"
  add_foreign_key "user_favorites", "sites"
  add_foreign_key "user_favorites", "users"
  add_foreign_key "user_tags", "tags"
  add_foreign_key "user_tags", "users"
  add_foreign_key "users", "msa_segments", column: "segment_id"
  add_foreign_key "users", "sites"
end
