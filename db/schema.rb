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

ActiveRecord::Schema.define(version: 2018_05_22_125523) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "audiences", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "name", limit: 50
    t.jsonb "predicates"
    t.string "predicate_type", limit: 10
  end

  create_table "boxes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "mac_address", limit: 18
    t.string "state", limit: 10
    t.string "machine_type", limit: 26
    t.text "description"
    t.datetime "last_heartbeat"
  end

  create_table "emails", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.integer "person_id"
    t.integer "station_id"
    t.string "email", limit: 100
    t.string "comments", limit: 50
    t.string "splash_id", limit: 50
    t.string "list_id", limit: 50
    t.string "list_type", limit: 50
    t.boolean "added", default: false
    t.boolean "active", default: true
    t.boolean "blocked"
    t.boolean "bounced"
    t.boolean "spam"
    t.boolean "unsubscribed"
    t.boolean "consented", default: false
    t.text "macs", array: true
    t.text "lists", array: true
  end

  create_table "event_logs", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "resource_id", limit: 10
    t.json "meta"
    t.json "data"
    t.json "response"
    t.string "event_type", limit: 12
  end

  create_table "location_users", force: :cascade do |t|
    t.string "unique_id", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "role_id"
    t.integer "user_id"
    t.integer "location_id"
  end

  create_table "locations", force: :cascade do |t|
    t.string "unique_id", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "location_name", limit: 255
    t.string "location_address", limit: 255
    t.string "town", limit: 255
    t.string "street", limit: 255
    t.string "postcode", limit: 255
    t.string "country", limit: 255, default: "United Kingdom"
    t.string "owner", limit: 255
    t.string "website", limit: 255
    t.string "geocode", limit: 255
    t.string "phone1", limit: 255
    t.integer "user_id"
    t.string "api_token", limit: 255
    t.string "slug", limit: 255
    t.float "latitude"
    t.float "longitude"
    t.boolean "has_devices", default: false
    t.string "timezone", limit: 255, default: "Europe/London"
    t.integer "lucky_dip"
    t.string "category", limit: 50
    t.boolean "demo", default: true
    t.boolean "eu", default: true
    t.boolean "paid", default: false
    t.index ["slug"], name: "index_locations_on_slug", unique: true
  end

  create_table "oauth_access_grants", force: :cascade do |t|
    t.integer "resource_owner_id", null: false
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.integer "expires_in", null: false
    t.text "redirect_uri", null: false
    t.datetime "created_at", null: false
    t.datetime "revoked_at"
    t.string "scopes"
    t.index ["application_id"], name: "index_oauth_access_grants_on_application_id"
    t.index ["token"], name: "index_oauth_access_grants_on_token", unique: true
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.integer "resource_owner_id"
    t.bigint "application_id"
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at"
    t.datetime "created_at", null: false
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.text "redirect_uri", null: false
    t.string "scopes", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "unique_id", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.integer "login_count"
    t.string "campaign_id", limit: 26
    t.string "client_mac", limit: 26
    t.string "username", limit: 26
    t.string "email", limit: 50
    t.string "first_name", limit: 50
    t.string "last_name", limit: 50
    t.string "google_id", limit: 26
    t.boolean "consented", default: true
    t.boolean "unsubscribed", default: false
    t.text "campaign_ids", array: true
    t.datetime "last_seen"
  end

  create_table "person_timelines", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.integer "person_id"
    t.string "event", limit: 20
    t.json "meta"
  end

  create_table "senders", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.integer "user_id"
    t.string "sender_name", limit: 50
    t.string "sender_type", limit: 50
    t.string "from_name", limit: 50
    t.string "from_email", limit: 50
    t.string "from_sms", limit: 50
    t.string "from_twitter", limit: 50
    t.string "twitter_token", limit: 50
    t.string "twitter_secret", limit: 50
    t.string "reply_email", limit: 50
    t.string "address", limit: 50
    t.string "town", limit: 50
    t.string "postcode", limit: 50
    t.string "country", limit: 50
    t.string "token", limit: 50
    t.boolean "is_validated"
  end

  create_table "sms", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "number", limit: 15
    t.integer "person_id"
    t.string "client_mac", limit: 18
  end

  create_table "socials", force: :cascade do |t|
    t.string "unique_id", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "facebook_id", limit: 24
    t.string "google_id", limit: 24
    t.string "email", limit: 50
    t.string "first_name", limit: 24
    t.string "last_name", limit: 24
    t.string "gender", limit: 6
    t.string "current_location", limit: 24
    t.string "twitter_id", limit: 24
    t.integer "person_id"
    t.integer "checkins"
    t.text "location_ids", array: true
    t.text "splash_ids", array: true
    t.text "emails", array: true
    t.text "client_ids", array: true
    t.text "networks", array: true
    t.text "lonlat", array: true
    t.boolean "newsletter", default: false
    t.json "meta"
  end

  create_table "splash_integrations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "api_token"
    t.string "host"
    t.string "integration_type", limit: 10
    t.string "port", limit: 5
    t.string "username", limit: 26
    t.string "password", limit: 26
    t.json "metadata", default: {}
    t.boolean "active"
  end

  create_table "splash_pages", force: :cascade do |t|
    t.string "unique_id", limit: 24
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.integer "registered_access_id"
    t.integer "primary_access_id"
    t.integer "access_period"
    t.integer "max_all_session"
    t.integer "container_transparency", default: 1
    t.integer "header_image_type", default: 1
    t.integer "weight", default: 100
    t.integer "newsletter_type", default: 0
    t.integer "access_restrict_mins", default: 60
    t.integer "access_restrict_down", default: 2048
    t.integer "access_restrict_up", default: 1024
    t.integer "download_speed", default: 2048
    t.integer "upload_speed", default: 1024
    t.integer "session_timeout", default: 60
    t.integer "idle_timeout", default: 60
    t.integer "simultaneous_use", default: 25
    t.integer "welcome_timeout"
    t.text "info"
    t.text "info_two"
    t.text "address"
    t.text "splash_name"
    t.text "description"
    t.text "header_text"
    t.text "error_message_text"
    t.text "gdpr_email_field", default: "I'd like to receive updates by Email"
    t.text "gdpr_sms_field", default: "I'd like to receive updates by SMS"
    t.text "gdpr_contact_message", default: "Occasionally we'd like to give you updates about products & services, promotions, special offers, news & events."
    t.text "font_family", default: "'Helvetica Neue', Arial, Helvetica, sans-serif"
    t.text "fb_checkin_msg"
    t.text "whitelisted"
    t.text "blacklisted"
    t.text "welcome_text"
    t.text "no_login_message"
    t.text "quota_message"
    t.text "walled_gardens"
    t.string "passwd_change_email", limit: 50
    t.string "logo_file_name", limit: 25
    t.string "background_image_name", limit: 25
    t.string "location_image_name", limit: 25
    t.string "header_image_name", limit: 25
    t.string "words_position", limit: 6, default: "right"
    t.string "logo_position", limit: 6, default: "left"
    t.string "container_float", limit: 6, default: "center"
    t.string "container_text_align", limit: 6, default: "center"
    t.string "container_inner_width", limit: 6, default: "100%"
    t.string "container_inner_padding", limit: 6, default: "20px"
    t.string "container_inner_radius", limit: 6, default: "4px"
    t.string "bg_dimension", limit: 6, default: "full"
    t.string "header_colour", limit: 22, default: "#FFFFFF"
    t.string "button_colour", limit: 22, default: "#FFFFFF"
    t.string "button_radius", limit: 6, default: "4px"
    t.string "button_border_colour", limit: 22, default: "#000"
    t.string "button_padding", limit: 10, default: "0px 16px"
    t.string "button_height", limit: 6, default: "50px"
    t.string "container_colour", limit: 22, default: "#FFFFFF"
    t.string "container_width", limit: 6, default: "850px"
    t.string "body_background_colour", limit: 22, default: "#FFFFFF"
    t.string "body_font_size", limit: 6, default: "14px"
    t.string "heading_text_size", limit: 6, default: "22px"
    t.string "heading_text_colour", limit: 22, default: "#000000"
    t.string "heading_2_text_size", limit: 6, default: "16px"
    t.string "heading_2_text_colour", limit: 22, default: "#000000"
    t.string "heading_3_text_size", limit: 6, default: "14px"
    t.string "heading_3_text_colour", limit: 22, default: "#000000"
    t.string "body_text_colour", limit: 22, default: "#333333"
    t.string "border_colour", limit: 22, default: "#CCCCCC"
    t.string "btn_text", limit: 25, default: "Login Now"
    t.string "reg_btn_text", limit: 25, default: "Register"
    t.string "btn_font_size", limit: 6, default: "18px"
    t.string "btn_font_colour", limit: 22, default: "#000000"
    t.string "link_colour", limit: 22, default: "#2B68B6"
    t.string "error_colour", limit: 22, default: "#ED561B"
    t.string "email_button_colour", limit: 22, default: "rgb(255, 255, 255)"
    t.string "email_button_border_colour", limit: 22, default: "rgb(204, 204, 204)"
    t.string "email_btn_font_colour", limit: 22, default: "rgb(0, 0, 0)"
    t.string "sms_button_colour", limit: 22, default: "rgb(239, 83, 80)"
    t.string "sms_button_border_colour", limit: 22, default: "rgba(239, 83, 80, 0)"
    t.string "sms_btn_font_colour", limit: 22, default: "rgb(255, 255, 255)"
    t.string "voucher_button_colour", limit: 22, default: "rgb(255, 255, 255)"
    t.string "voucher_button_border_colour", limit: 22, default: "rgb(204, 204, 204)"
    t.string "voucher_btn_font_colour", limit: 22, default: "rgb(0, 0, 0)"
    t.string "codes_button_colour", limit: 22, default: "rgb(255, 255, 255)"
    t.string "codes_button_border_colour", limit: 22, default: "rgb(204, 204, 204)"
    t.string "codes_btn_font_colour", limit: 22, default: "rgb(0, 0, 0)"
    t.string "password_button_colour", limit: 22, default: "rgb(255, 255, 255)"
    t.string "password_button_border_colour", limit: 22, default: "rgb(204, 204, 204)"
    t.string "password_btn_font_colour", limit: 22, default: "rgb(0, 0, 0)"
    t.string "access_restrict", limit: 10, default: "none"
    t.string "access_restrict_period", limit: 10, default: "daily"
    t.string "available_start", limit: 10, default: "00:00"
    t.string "available_end", limit: 10, default: "00:00"
    t.string "input_padding", limit: 10, default: "10px 15px"
    t.string "input_height", limit: 10, default: "40px"
    t.string "input_border_colour", limit: 22, default: "#d0d0d0"
    t.string "input_border_width", limit: 6, default: "1px"
    t.string "input_border_radius", limit: 6, default: "0px"
    t.string "input_required_colour", limit: 10, default: "#CCC"
    t.string "input_required_size", limit: 10, default: "10px"
    t.string "input_background", limit: 22, default: "#FFFFFF"
    t.string "input_text_colour", limit: 22, default: "#3D3D3D"
    t.string "input_max_width", limit: 6, default: "400px"
    t.string "footer_text_colour", limit: 22, default: "#CCC"
    t.string "timezone", limit: 32, default: "Europe/London"
    t.string "popup_background_colour", limit: 22, default: "rgb(255,255,255)"
    t.string "password", limit: 25
    t.string "fb_page_id", limit: 25
    t.string "fb_app_id", limit: 25
    t.string "fb_link", limit: 255
    t.string "success_url", limit: 255
    t.string "terms_url", limit: 255
    t.string "website", limit: 255
    t.string "external_css", limit: 255
    t.string "newsletter_api_token", limit: 255
    t.string "newsletter_list_id", limit: 32
    t.string "facebook_name", limit: 32
    t.string "google_name", limit: 32
    t.string "twitter_name", limit: 32
    t.string "g_api_key", limit: 10
    t.string "g_page_id", limit: 10
    t.string "splash_integration_id", limit: 24
    t.string "tw_handle", limit: 32
    t.string "vsg_host", limit: 255
    t.string "vsg_pass", limit: 50
    t.string "uamsecret", limit: 32
    t.string "default_password", limit: 32
    t.string "popup_image", limit: 10
    t.boolean "backup_sms", default: false
    t.boolean "backup_email", default: true
    t.boolean "backup_vouchers", default: false
    t.boolean "backup_password", default: false
    t.boolean "backup_quick_codes", default: false
    t.boolean "active", default: true
    t.boolean "fb_checkin", default: false
    t.boolean "fb_msg", default: true
    t.boolean "fb_use_ps", default: true
    t.boolean "g_use_ps", default: true
    t.boolean "fb_login_on", default: false
    t.boolean "secondary_access", default: false
    t.boolean "passwd_auto_gen", default: false
    t.boolean "skip_user_registration", default: false
    t.boolean "g_redirect_to_page", default: false
    t.boolean "g_login_on", default: false
    t.boolean "tw_send_tweet", default: false
    t.boolean "tw_login_on", default: false
    t.boolean "allow_registration", default: false
    t.boolean "show_welcome", default: false
    t.boolean "fb_redirect_to_page", default: false
    t.boolean "powered_by", default: true
    t.boolean "email_required", default: false
    t.boolean "newsletter_consent", default: false
    t.boolean "vsg_enabled"
    t.boolean "no_login"
    t.boolean "hide_terms", default: false
    t.boolean "single_opt_in", default: false
    t.boolean "double_opt_in", default: true
    t.boolean "merge_fields", default: false
    t.boolean "debug", default: false
    t.boolean "vsg_async", default: true
    t.boolean "display_console", default: false
    t.boolean "bypass_popup_android", default: false
    t.boolean "bypass_popup_ios", default: false
    t.boolean "popup_ad", default: false
    t.boolean "gdpr_form", default: true
    t.boolean "email_button_icon", default: true
    t.boolean "codes_button_icon", default: true
    t.boolean "password_button_icon", default: true
    t.boolean "voucher_button_icon", default: true
    t.boolean "sms_button_icon", default: false
    t.boolean "meraki_enabled"
    t.boolean "unifi_enabled"
    t.boolean "cloudtrax_enabled"
    t.boolean "button_shadow", default: true
    t.boolean "container_shadow", default: true
    t.text "available_days", array: true
    t.text "passwd_change_day", array: true
    t.text "tags", array: true
    t.text "networks", array: true
    t.boolean "newsletter_active", default: false
    t.string "twilio_user", limit: 50
    t.string "twilio_pass", limit: 50
    t.string "twilio_from", limit: 15
    t.index ["location_id"], name: "index_splash_on_location_id"
  end

  create_table "stations", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "location_id"
    t.string "ssid"
    t.string "36"
    t.string "client_mac"
    t.string "18"
    t.integer "person_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin"
    t.integer "role"
    t.time "locked_at"
    t.integer "failed_attempts"
    t.string "username", limit: 50
    t.string "timezone", limit: 26
    t.string "country", limit: 26
    t.string "account_id", limit: 10
    t.string "slug"
    t.string "locale", limit: 2
    t.string "radius_secret"
    t.string "alerts_window_start", limit: 5
    t.string "alerts_window_end", limit: 5
    t.text "alerts_window_days", array: true
    t.boolean "alerts", default: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "oauth_access_grants", "oauth_applications", column: "application_id"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
end
