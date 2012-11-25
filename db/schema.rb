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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20121125052143) do

  create_table "community_members", :force => true do |t|
    t.string   "street_address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "primary_language", :default => "english"
    t.date     "date_of_birth"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "name"
  end

  add_index "community_members", ["user_id"], :name => "index_community_members_on_user_id"

  create_table "consent_texts", :force => true do |t|
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "consents", :force => true do |t|
    t.date     "date",            :default => '2012-11-25'
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.integer  "consent_text_id"
  end

  add_index "consents", ["consent_text_id"], :name => "index_consents_on_consent_text_id"
  add_index "consents", ["user_id"], :name => "index_consents_on_user_id"

  create_table "data_points", :force => true do |t|
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_enrollment_id"
  end

  add_index "data_points", ["study_enrollment_id"], :name => "index_data_points_on_study_enrollment_id"

  create_table "managers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "managers", ["user_id"], :name => "index_managers_on_user_id"

  create_table "researchers", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "street_address"
    t.string   "city"
    t.string   "province"
    t.string   "postal_code"
    t.string   "phone"
    t.string   "primary_language", :default => "english"
    t.date     "date_of_birth"
    t.string   "name"
    t.string   "state",            :default => "not_approved"
    t.datetime "key_timestamp"
  end

  add_index "researchers", ["state"], :name => "index_researchers_on_state"
  add_index "researchers", ["user_id"], :name => "index_researchers_on_user_id"

  create_table "studies", :force => true do |t|
    t.string   "title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "body"
    t.string   "state",           :default => "no_consent"
    t.datetime "key_timestamp"
    t.integer  "consent_text_id"
    t.integer  "test_module_id"
  end

  add_index "studies", ["consent_text_id"], :name => "index_studies_on_consent_text_id"
  add_index "studies", ["state"], :name => "index_studies_on_state"
  add_index "studies", ["test_module_id"], :name => "index_studies_on_test_module_id"

  create_table "study_enrollments", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_id"
    t.integer  "community_member_id"
    t.string   "secret_key"
    t.string   "state",               :default => "enrolled"
    t.datetime "key_timestamp"
  end

  add_index "study_enrollments", ["community_member_id"], :name => "index_study_enrollments_on_community_member_id"
  add_index "study_enrollments", ["state"], :name => "index_study_enrollments_on_state"
  add_index "study_enrollments", ["study_id"], :name => "index_study_enrollments_on_study_id"

  create_table "study_invitations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_id"
    t.integer  "community_member_id"
    t.string   "state",               :default => "invited"
    t.datetime "key_timestamp"
    t.boolean  "consent_accepted",    :default => false
  end

  add_index "study_invitations", ["community_member_id"], :name => "index_study_invitations_on_community_member_id"
  add_index "study_invitations", ["state"], :name => "index_study_invitations_on_state"
  add_index "study_invitations", ["study_id"], :name => "index_study_invitations_on_study_id"

  create_table "study_ownerships", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "study_id"
    t.integer  "researcher_id"
  end

  add_index "study_ownerships", ["researcher_id"], :name => "index_study_ownerships_on_researcher_id"
  add_index "study_ownerships", ["study_id"], :name => "index_study_ownerships_on_study_id"

  create_table "test_modules", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "module_identifier"
  end

  create_table "users", :force => true do |t|
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.string   "email_address"
    t.boolean  "administrator",                           :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state",                                   :default => "inactive"
    t.datetime "key_timestamp"
    t.boolean  "general_consent_accepted",                :default => false
    t.string   "user_type",                               :default => "community"
  end

  add_index "users", ["state"], :name => "index_users_on_state"

end
