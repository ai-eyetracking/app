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

ActiveRecord::Schema[7.1].define(version: 2025_06_19_171358) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "analyses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "analysis_type", default: 0, null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_analyses_on_project_id"
  end

  create_table "analysis_versions", force: :cascade do |t|
    t.bigint "analysis_id", null: false
    t.integer "version_number", null: false
    t.string "image_path", null: false
    t.json "heatmap_data"
    t.json "custom_scoring"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_id", "version_number"], name: "index_analysis_versions_on_analysis_id_and_version_number", unique: true
    t.index ["analysis_id"], name: "index_analysis_versions_on_analysis_id"
  end

  create_table "key_areas", force: :cascade do |t|
    t.bigint "analysis_id", null: false
    t.string "name", null: false
    t.decimal "x", precision: 5, scale: 2, null: false
    t.decimal "y", precision: 5, scale: 2, null: false
    t.decimal "width", precision: 5, scale: 2, null: false
    t.decimal "height", precision: 5, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["analysis_id"], name: "index_key_areas_on_analysis_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "title", null: false
    t.text "description"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "title"], name: "index_projects_on_user_id_and_title"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "analyses", "projects"
  add_foreign_key "analysis_versions", "analyses"
  add_foreign_key "key_areas", "analyses"
  add_foreign_key "projects", "users"
end
