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

ActiveRecord::Schema.define(version: 2019_09_23_174453) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "postgis"

  create_table "active_admin_comments", id: :serial, force: :cascade do |t|
    t.string "namespace", limit: 255
    t.text "body"
    t.string "resource_id", limit: 255, null: false
    t.string "resource_type", limit: 255, null: false
    t.integer "author_id"
    t.string "author_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.integer "trackable_id"
    t.string "trackable_type", limit: 255
    t.integer "owner_id"
    t.string "owner_type", limit: 255
    t.string "key", limit: 255
    t.text "parameters"
    t.integer "recipient_id"
    t.string "recipient_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["owner_id", "owner_type"], name: "index_activities_on_owner_id_and_owner_type"
    t.index ["recipient_id", "recipient_type"], name: "index_activities_on_recipient_id_and_recipient_type"
    t.index ["trackable_id", "trackable_type"], name: "index_activities_on_trackable_id_and_trackable_type"
  end

  create_table "addresses", id: :serial, force: :cascade do |t|
    t.string "street_name", limit: 255
    t.string "street_number", limit: 255
    t.string "zip", limit: 255
    t.string "city", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "coordinates", limit: {:srid=>0, :type=>"st_point"}
    t.integer "addressable_id"
    t.string "addressable_type", limit: 255
    t.string "description", limit: 255
    t.index ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type"
  end

  create_table "api_accounts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "api_key"
    t.boolean "enabled", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_addresses", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.string "first_name"
    t.string "last_name"
    t.string "company"
    t.string "street"
    t.string "zip"
    t.string "city"
    t.string "country", default: "Austria"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["location_id"], name: "index_billing_addresses_on_location_id"
  end

  create_table "business_interests", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mailchimp_id"
  end

  create_table "business_interests_users", id: false, force: :cascade do |t|
    t.integer "business_interest_id"
    t.integer "user_id"
    t.index ["business_interest_id"], name: "index_business_interests_users_on_business_interest_id"
    t.index ["user_id"], name: "index_business_interests_users_on_user_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "user_id"
    t.integer "commentable_id"
    t.string "commentable_type", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "website"
    t.string "email"
    t.string "phone"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "hours"
    t.index ["location_id"], name: "index_contacts_on_location_id"
  end

  create_table "curators", id: :serial, force: :cascade do |t|
    t.integer "graetzl_id"
    t.integer "user_id"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["graetzl_id"], name: "index_curators_on_graetzl_id"
    t.index ["user_id"], name: "index_curators_on_user_id"
  end

  create_table "discussion_categories", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_discussion_categories_on_group_id"
    t.index ["title"], name: "index_discussion_categories_on_title"
  end

  create_table "discussion_default_categories", id: :serial, force: :cascade do |t|
    t.string "title"
  end

  create_table "discussion_followings", id: :serial, force: :cascade do |t|
    t.integer "discussion_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discussion_id"], name: "index_discussion_followings_on_discussion_id"
    t.index ["user_id"], name: "index_discussion_followings_on_user_id"
  end

  create_table "discussion_posts", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "discussion_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "initial_post", default: false
    t.index ["discussion_id"], name: "index_discussion_posts_on_discussion_id"
    t.index ["user_id"], name: "index_discussion_posts_on_user_id"
  end

  create_table "discussions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.boolean "closed", default: false
    t.boolean "sticky", default: false
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "last_post_at"
    t.integer "discussion_category_id"
    t.index ["discussion_category_id"], name: "index_discussions_on_discussion_category_id"
    t.index ["group_id", "sticky", "last_post_at"], name: "index_discussions_on_group_id_and_sticky_and_last_post_at"
    t.index ["group_id"], name: "index_discussions_on_group_id"
    t.index ["user_id"], name: "index_discussions_on_user_id"
  end

  create_table "district_graetzls", id: :serial, force: :cascade do |t|
    t.integer "district_id"
    t.integer "graetzl_id"
    t.index ["district_id"], name: "index_district_graetzls_on_district_id"
    t.index ["graetzl_id"], name: "index_district_graetzls_on_graetzl_id"
  end

  create_table "districts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "zip", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "area", limit: {:srid=>0, :type=>"st_polygon"}
    t.string "slug", limit: 255
    t.index ["slug"], name: "index_districts_on_slug"
  end

  create_table "friendly_id_slugs", id: :serial, force: :cascade do |t|
    t.string "slug", limit: 255, null: false
    t.integer "sluggable_id", null: false
    t.string "sluggable_type", limit: 50
    t.string "scope", limit: 255
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type"
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id"
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type"
  end

  create_table "going_tos", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "meeting_id"
    t.integer "role", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["meeting_id"], name: "index_going_tos_on_meeting_id"
    t.index ["user_id"], name: "index_going_tos_on_user_id"
  end

  create_table "graetzls", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.geometry "area", limit: {:srid=>0, :type=>"st_polygon"}
    t.string "slug", limit: 255
    t.integer "users_count", default: 0
    t.index ["slug"], name: "index_graetzls_on_slug"
  end

  create_table "group_categories", id: :serial, force: :cascade do |t|
    t.string "title"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "group_categories_groups", id: false, force: :cascade do |t|
    t.integer "group_category_id", null: false
    t.integer "group_id", null: false
    t.index ["group_category_id"], name: "index_group_categories_groups_on_group_category_id"
    t.index ["group_id"], name: "index_group_categories_groups_on_group_id"
  end

  create_table "group_graetzls", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "graetzl_id"
    t.index ["graetzl_id"], name: "index_group_graetzls_on_graetzl_id"
    t.index ["group_id"], name: "index_group_graetzls_on_group_id"
  end

  create_table "group_join_questions", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.text "question"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_join_questions_on_group_id"
  end

  create_table "group_join_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.boolean "rejected", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "request_message"
    t.text "response_message"
    t.text "join_answers", default: [], array: true
    t.integer "status", default: 0
    t.index ["group_id"], name: "index_group_join_requests_on_group_id"
    t.index ["user_id"], name: "index_group_join_requests_on_user_id"
  end

  create_table "group_users", id: :serial, force: :cascade do |t|
    t.integer "group_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.index ["group_id"], name: "index_group_users_on_group_id"
    t.index ["user_id"], name: "index_group_users_on_user_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "room_offer_id"
    t.boolean "private", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_call_id"
    t.integer "room_demand_id"
    t.integer "location_id"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.boolean "featured", default: false
    t.boolean "hidden", default: false
    t.text "welcome_message"
    t.index ["location_id"], name: "index_groups_on_location_id"
    t.index ["room_call_id"], name: "index_groups_on_room_call_id"
    t.index ["room_demand_id"], name: "index_groups_on_room_demand_id"
    t.index ["room_offer_id"], name: "index_groups_on_room_offer_id"
  end

  create_table "images", id: :serial, force: :cascade do |t|
    t.string "file_id"
    t.integer "imageable_id"
    t.string "imageable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_content_type"
    t.index ["imageable_type", "imageable_id"], name: "index_images_on_imageable_type_and_imageable_id"
  end

  create_table "initiatives", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "image_id"
    t.string "image_content_type"
    t.string "website"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "location_categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "context", default: 0
    t.string "icon"
  end

  create_table "location_ownerships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.index ["location_id"], name: "index_location_ownerships_on_location_id"
    t.index ["user_id"], name: "index_location_ownerships_on_user_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slogan"
    t.text "description"
    t.string "avatar_id"
    t.string "cover_photo_id"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "graetzl_id"
    t.string "avatar_content_type"
    t.string "cover_photo_content_type"
    t.integer "state", default: 0
    t.integer "meeting_permission", default: 0, null: false
    t.integer "location_category_id"
    t.datetime "last_activity_at"
    t.index ["created_at"], name: "index_locations_on_created_at"
    t.index ["graetzl_id"], name: "index_locations_on_graetzl_id"
    t.index ["last_activity_at"], name: "index_locations_on_last_activity_at"
    t.index ["slug"], name: "index_locations_on_slug"
  end

  create_table "meetings", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug", limit: 255
    t.date "starts_at_date"
    t.date "ends_at_date"
    t.time "starts_at_time"
    t.time "ends_at_time"
    t.integer "graetzl_id"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.integer "location_id"
    t.integer "state", default: 0
    t.boolean "approved_for_api", default: false
    t.integer "group_id"
    t.boolean "private", default: false
    t.integer "user_id"
    t.index ["created_at"], name: "index_meetings_on_created_at"
    t.index ["graetzl_id"], name: "index_meetings_on_graetzl_id"
    t.index ["group_id"], name: "index_meetings_on_group_id"
    t.index ["location_id"], name: "index_meetings_on_location_id"
    t.index ["slug"], name: "index_meetings_on_slug"
    t.index ["user_id"], name: "index_meetings_on_user_id"
  end

  create_table "notifications", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "activity_id"
    t.integer "bitmask", null: false
    t.boolean "seen", default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "sent", default: false
    t.boolean "display_on_website", default: false
    t.string "type"
    t.date "notify_at"
    t.date "notify_before"
    t.index ["user_id", "notify_at"], name: "index_notifications_on_user_id_and_notify_at"
  end

  create_table "operating_ranges", id: :serial, force: :cascade do |t|
    t.integer "graetzl_id"
    t.integer "operator_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "operator_type"
    t.index ["graetzl_id"], name: "index_operating_ranges_on_graetzl_id"
    t.index ["operator_id", "operator_type"], name: "index_operating_ranges_on_operator_id_and_operator_type"
  end

  create_table "posts", id: :serial, force: :cascade do |t|
    t.text "content"
    t.integer "graetzl_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "slug"
    t.string "title"
    t.integer "author_id"
    t.string "author_type"
    t.string "type"
    t.index ["author_type", "author_id"], name: "index_posts_on_author_type_and_author_id"
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["graetzl_id"], name: "index_posts_on_graetzl_id"
    t.index ["slug"], name: "index_posts_on_slug", unique: true
  end

  create_table "room_call_fields", id: :serial, force: :cascade do |t|
    t.integer "room_call_id"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_call_id"], name: "index_room_call_fields_on_room_call_id"
  end

  create_table "room_call_modules", id: :serial, force: :cascade do |t|
    t.integer "room_call_id"
    t.integer "room_module_id"
    t.integer "quantity", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "description"
    t.index ["room_call_id"], name: "index_room_call_modules_on_room_call_id"
    t.index ["room_module_id"], name: "index_room_call_modules_on_room_module_id"
  end

  create_table "room_call_price_modules", id: :serial, force: :cascade do |t|
    t.integer "room_call_price_id"
    t.integer "room_module_id"
    t.index ["room_call_price_id"], name: "index_room_call_price_modules_on_room_call_price_id"
    t.index ["room_module_id"], name: "index_room_call_price_modules_on_room_module_id"
  end

  create_table "room_call_prices", id: :serial, force: :cascade do |t|
    t.integer "room_call_id"
    t.string "name"
    t.text "description"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "features"
    t.index ["room_call_id"], name: "index_room_call_prices_on_room_call_id"
  end

  create_table "room_call_submission_fields", id: :serial, force: :cascade do |t|
    t.integer "room_call_submission_id"
    t.integer "room_call_field_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_call_field_id"], name: "index_room_call_submission_fields_on_room_call_field_id"
    t.index ["room_call_submission_id"], name: "index_room_call_submission_fields_on_room_call_submission_id"
  end

  create_table "room_call_submissions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "room_call_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "phone"
    t.string "website"
    t.index ["room_call_id"], name: "index_room_call_submissions_on_room_call_id"
    t.index ["user_id"], name: "index_room_call_submissions_on_user_id"
  end

  create_table "room_calls", id: :serial, force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.date "starts_at"
    t.date "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subtitle"
    t.text "about_us"
    t.text "about_partner"
    t.date "opens_at"
    t.string "slug"
    t.integer "total_vacancies", default: 0
    t.integer "graetzl_id"
    t.integer "district_id"
    t.integer "user_id"
    t.integer "location_id"
    t.string "first_name"
    t.string "last_name"
    t.string "website"
    t.string "email"
    t.string "phone"
    t.string "avatar_id"
    t.string "avatar_content_type"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.index ["district_id"], name: "index_room_calls_on_district_id"
    t.index ["graetzl_id"], name: "index_room_calls_on_graetzl_id"
    t.index ["location_id"], name: "index_room_calls_on_location_id"
    t.index ["user_id"], name: "index_room_calls_on_user_id"
  end

  create_table "room_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "room_demand_categories", id: :serial, force: :cascade do |t|
    t.integer "room_category_id"
    t.integer "room_demand_id"
    t.index ["room_category_id"], name: "index_room_demand_categories_on_room_category_id"
    t.index ["room_demand_id"], name: "index_room_demand_categories_on_room_demand_id"
  end

  create_table "room_demand_graetzls", id: :serial, force: :cascade do |t|
    t.integer "graetzl_id"
    t.integer "room_demand_id"
    t.index ["graetzl_id"], name: "index_room_demand_graetzls_on_graetzl_id"
    t.index ["room_demand_id"], name: "index_room_demand_graetzls_on_room_demand_id"
  end

  create_table "room_demands", id: :serial, force: :cascade do |t|
    t.string "slogan"
    t.decimal "needed_area", precision: 10, scale: 2
    t.text "demand_description"
    t.text "personal_description"
    t.boolean "wants_collaboration"
    t.string "slug"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "demand_type", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "website"
    t.string "email"
    t.string "phone"
    t.integer "location_id"
    t.string "avatar_id"
    t.string "avatar_content_type"
    t.integer "status", default: 0
    t.index ["location_id"], name: "index_room_demands_on_location_id"
    t.index ["user_id"], name: "index_room_demands_on_user_id"
  end

  create_table "room_modules", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "icon"
  end

  create_table "room_offer_categories", id: :serial, force: :cascade do |t|
    t.integer "room_category_id"
    t.integer "room_offer_id"
    t.index ["room_category_id"], name: "index_room_offer_categories_on_room_category_id"
    t.index ["room_offer_id"], name: "index_room_offer_categories_on_room_offer_id"
  end

  create_table "room_offer_prices", id: :serial, force: :cascade do |t|
    t.integer "room_offer_id"
    t.string "name"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_offer_id"], name: "index_room_offer_prices_on_room_offer_id"
  end

  create_table "room_offer_waiting_users", id: :serial, force: :cascade do |t|
    t.integer "room_offer_id"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["room_offer_id"], name: "index_room_offer_waiting_users_on_room_offer_id"
    t.index ["user_id"], name: "index_room_offer_waiting_users_on_user_id"
  end

  create_table "room_offers", id: :serial, force: :cascade do |t|
    t.string "slogan"
    t.text "room_description"
    t.decimal "total_area", precision: 10, scale: 2
    t.decimal "rented_area", precision: 10, scale: 2
    t.text "owner_description"
    t.text "tenant_description"
    t.boolean "wants_collaboration"
    t.string "slug"
    t.integer "user_id"
    t.integer "location_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "graetzl_id"
    t.integer "district_id"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.integer "offer_type", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "website"
    t.string "email"
    t.string "phone"
    t.string "avatar_id"
    t.string "avatar_content_type"
    t.integer "status", default: 0
    t.index ["district_id"], name: "index_room_offers_on_district_id"
    t.index ["graetzl_id"], name: "index_room_offers_on_graetzl_id"
    t.index ["location_id"], name: "index_room_offers_on_location_id"
    t.index ["user_id"], name: "index_room_offers_on_user_id"
  end

  create_table "room_suggested_tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.integer "taggable_id"
    t.string "taggable_type"
    t.integer "tagger_id"
    t.string "tagger_type"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "tool_categories", force: :cascade do |t|
    t.string "name"
    t.integer "parent_category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "main_photo_id"
    t.string "main_photo_content_type"
    t.integer "position", default: 0
    t.index ["parent_category_id"], name: "index_tool_categories_on_parent_category_id"
  end

  create_table "tool_offers", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.text "description"
    t.string "brand"
    t.string "model"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.bigint "tool_category_id"
    t.integer "tool_subcategory_id"
    t.bigint "user_id"
    t.bigint "location_id"
    t.bigint "graetzl_id"
    t.integer "value_up_to"
    t.string "serial_number"
    t.text "known_defects"
    t.decimal "price_per_day", precision: 10, scale: 2
    t.integer "two_day_discount", default: 0
    t.integer "weekly_discount", default: 0
    t.integer "status", default: 0
    t.string "first_name"
    t.string "last_name"
    t.string "iban"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["graetzl_id"], name: "index_tool_offers_on_graetzl_id"
    t.index ["location_id"], name: "index_tool_offers_on_location_id"
    t.index ["status"], name: "index_tool_offers_on_status"
    t.index ["tool_category_id"], name: "index_tool_offers_on_tool_category_id"
    t.index ["tool_subcategory_id"], name: "index_tool_offers_on_tool_subcategory_id"
    t.index ["user_id"], name: "index_tool_offers_on_user_id"
  end

  create_table "tool_rentals", force: :cascade do |t|
    t.bigint "tool_offer_id"
    t.bigint "user_id"
    t.date "rent_from"
    t.date "rent_to"
    t.string "renter_company"
    t.string "renter_name"
    t.string "renter_address"
    t.string "renter_zip"
    t.string "renter_city"
    t.integer "rental_status", default: 0
    t.string "stripe_payment_intent_id"
    t.integer "owner_rating"
    t.integer "renter_rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_method"
    t.decimal "basic_price", precision: 10, scale: 2, default: "0.0"
    t.decimal "discount", precision: 10, scale: 2, default: "0.0"
    t.decimal "service_fee", precision: 10, scale: 2, default: "0.0"
    t.decimal "insurance_fee", precision: 10, scale: 2, default: "0.0"
    t.integer "payment_status", default: 0
    t.string "stripe_source_id"
    t.string "stripe_charge_id"
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.string "invoice_number"
    t.index ["stripe_payment_intent_id"], name: "index_tool_rentals_on_stripe_payment_intent_id"
    t.index ["tool_offer_id"], name: "index_tool_rentals_on_tool_offer_id"
    t.index ["user_id"], name: "index_tool_rentals_on_user_id"
  end

  create_table "user_message_thread_members", force: :cascade do |t|
    t.bigint "user_message_thread_id"
    t.bigint "user_id"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "last_message_seen_id", default: 0
    t.index ["user_id"], name: "index_user_message_thread_members_on_user_id"
    t.index ["user_message_thread_id"], name: "index_user_message_thread_members_on_user_message_thread_id"
  end

  create_table "user_message_threads", force: :cascade do |t|
    t.bigint "tool_rental_id"
    t.datetime "last_message_at"
    t.text "last_message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["last_message"], name: "index_user_message_threads_on_last_message"
    t.index ["tool_rental_id"], name: "index_user_message_threads_on_tool_rental_id"
  end

  create_table "user_messages", force: :cascade do |t|
    t.bigint "user_message_thread_id"
    t.bigint "user_id"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_messages_on_user_id"
    t.index ["user_message_thread_id"], name: "index_user_messages_on_user_message_thread_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 255
    t.string "last_sign_in_ip", limit: 255
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "username", limit: 255
    t.string "first_name", limit: 255
    t.string "last_name", limit: 255
    t.boolean "newsletter", default: false, null: false
    t.integer "graetzl_id"
    t.string "avatar_id"
    t.integer "enabled_website_notifications", default: 0
    t.integer "role"
    t.string "avatar_content_type"
    t.integer "immediate_mail_notifications", default: 0
    t.integer "daily_mail_notifications", default: 0
    t.integer "weekly_mail_notifications", default: 0
    t.string "slug"
    t.string "cover_photo_id"
    t.string "cover_photo_content_type"
    t.text "bio"
    t.string "website"
    t.string "origin"
    t.integer "location_category_id"
    t.boolean "business", default: false
    t.string "stripe_customer_id", limit: 50
    t.string "iban"
    t.decimal "rating", precision: 3, scale: 2
    t.integer "ratings_count", default: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_at"], name: "index_users_on_created_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["graetzl_id"], name: "index_users_on_graetzl_id"
    t.index ["location_category_id"], name: "index_users_on_location_category_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["slug"], name: "index_users_on_slug", unique: true
    t.index ["stripe_customer_id"], name: "index_users_on_stripe_customer_id"
  end

  create_table "zuckerls", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.string "title"
    t.text "description"
    t.string "image_id"
    t.string "image_content_type"
    t.boolean "flyer", default: false
    t.string "aasm_state"
    t.datetime "paid_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "initiative_id"
    t.string "slug"
    t.index ["initiative_id"], name: "index_zuckerls_on_initiative_id"
    t.index ["location_id"], name: "index_zuckerls_on_location_id"
    t.index ["slug"], name: "index_zuckerls_on_slug"
  end

  add_foreign_key "business_interests_users", "business_interests", on_delete: :cascade
  add_foreign_key "business_interests_users", "users", on_delete: :cascade
  add_foreign_key "discussion_categories", "groups", on_delete: :cascade
  add_foreign_key "discussion_followings", "discussions", on_delete: :cascade
  add_foreign_key "discussion_followings", "users", on_delete: :cascade
  add_foreign_key "discussion_posts", "discussions", on_delete: :cascade
  add_foreign_key "discussion_posts", "users", on_delete: :nullify
  add_foreign_key "discussions", "discussion_categories", on_delete: :nullify
  add_foreign_key "discussions", "groups", on_delete: :cascade
  add_foreign_key "discussions", "users", on_delete: :nullify
  add_foreign_key "district_graetzls", "districts", on_delete: :cascade
  add_foreign_key "district_graetzls", "graetzls", on_delete: :cascade
  add_foreign_key "group_graetzls", "graetzls", on_delete: :cascade
  add_foreign_key "group_graetzls", "groups", on_delete: :cascade
  add_foreign_key "group_join_questions", "groups", on_delete: :cascade
  add_foreign_key "group_join_requests", "groups", on_delete: :cascade
  add_foreign_key "group_join_requests", "users", on_delete: :cascade
  add_foreign_key "group_users", "groups", on_delete: :cascade
  add_foreign_key "group_users", "users", on_delete: :cascade
  add_foreign_key "groups", "locations", on_delete: :nullify
  add_foreign_key "groups", "room_calls", on_delete: :nullify
  add_foreign_key "groups", "room_demands", on_delete: :nullify
  add_foreign_key "groups", "room_offers", on_delete: :nullify
  add_foreign_key "meetings", "groups", on_delete: :nullify
  add_foreign_key "meetings", "users", on_delete: :nullify
  add_foreign_key "notifications", "activities", on_delete: :cascade
  add_foreign_key "room_call_fields", "room_calls", on_delete: :cascade
  add_foreign_key "room_call_modules", "room_calls", on_delete: :cascade
  add_foreign_key "room_call_modules", "room_modules", on_delete: :cascade
  add_foreign_key "room_call_price_modules", "room_call_prices", on_delete: :cascade
  add_foreign_key "room_call_price_modules", "room_modules", on_delete: :cascade
  add_foreign_key "room_call_prices", "room_calls", on_delete: :cascade
  add_foreign_key "room_call_submission_fields", "room_call_fields", on_delete: :cascade
  add_foreign_key "room_call_submission_fields", "room_call_submissions", on_delete: :cascade
  add_foreign_key "room_call_submissions", "room_calls", on_delete: :cascade
  add_foreign_key "room_call_submissions", "users", on_delete: :nullify
  add_foreign_key "room_calls", "districts", on_delete: :nullify
  add_foreign_key "room_calls", "graetzls", on_delete: :nullify
  add_foreign_key "room_calls", "locations", on_delete: :nullify
  add_foreign_key "room_calls", "users", on_delete: :nullify
  add_foreign_key "room_demand_categories", "room_categories", on_delete: :cascade
  add_foreign_key "room_demand_categories", "room_demands", on_delete: :cascade
  add_foreign_key "room_demand_graetzls", "graetzls", on_delete: :cascade
  add_foreign_key "room_demand_graetzls", "room_demands", on_delete: :cascade
  add_foreign_key "room_demands", "locations", on_delete: :nullify
  add_foreign_key "room_demands", "users", on_delete: :cascade
  add_foreign_key "room_offer_categories", "room_categories", on_delete: :cascade
  add_foreign_key "room_offer_categories", "room_offers", on_delete: :cascade
  add_foreign_key "room_offer_prices", "room_offers", on_delete: :cascade
  add_foreign_key "room_offer_waiting_users", "room_offers", on_delete: :cascade
  add_foreign_key "room_offer_waiting_users", "users", on_delete: :cascade
  add_foreign_key "room_offers", "districts", on_delete: :nullify
  add_foreign_key "room_offers", "graetzls", on_delete: :nullify
  add_foreign_key "room_offers", "locations", on_delete: :nullify
  add_foreign_key "room_offers", "users", on_delete: :cascade
  add_foreign_key "tool_offers", "graetzls", on_delete: :nullify
  add_foreign_key "tool_offers", "locations", on_delete: :nullify
  add_foreign_key "tool_offers", "tool_categories", on_delete: :nullify
  add_foreign_key "tool_offers", "users", on_delete: :cascade
  add_foreign_key "tool_rentals", "tool_offers", on_delete: :nullify
  add_foreign_key "tool_rentals", "users", on_delete: :nullify
  add_foreign_key "user_message_thread_members", "user_message_threads", on_delete: :cascade
  add_foreign_key "user_message_thread_members", "users", on_delete: :cascade
  add_foreign_key "user_message_threads", "tool_rentals", on_delete: :nullify
  add_foreign_key "user_messages", "user_message_threads", on_delete: :cascade
  add_foreign_key "user_messages", "users", on_delete: :cascade
  add_foreign_key "users", "location_categories", on_delete: :nullify
end
