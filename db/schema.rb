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

ActiveRecord::Schema.define(version: 2021_07_20_215800) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string "username"
    t.string "password_digest"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "grade_categories", force: :cascade do |t|
    t.bigint "klass_id", null: false
    t.bigint "student_id"
    t.string "category"
    t.string "student_grade"
    t.integer "year"
    t.integer "semester"
    t.text "comment"
    t.boolean "locked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["klass_id"], name: "index_grade_categories_on_klass_id"
    t.index ["student_id"], name: "index_grade_categories_on_student_id"
  end

  create_table "klasses", force: :cascade do |t|
    t.bigint "teacher_id", null: false
    t.string "subject"
    t.string "grade"
    t.boolean "locked"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["teacher_id"], name: "index_klasses_on_teacher_id"
  end

  create_table "parents", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "username"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_parents_on_admin_id"
  end

  create_table "students", force: :cascade do |t|
    t.bigint "parent_id", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birth_date"
    t.string "picture_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_id"], name: "index_students_on_parent_id"
  end

  create_table "teachers", force: :cascade do |t|
    t.bigint "admin_id", null: false
    t.string "username"
    t.string "password_digest"
    t.string "title"
    t.string "first_name"
    t.string "last_name"
    t.string "picture_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["admin_id"], name: "index_teachers_on_admin_id"
  end

  add_foreign_key "grade_categories", "klasses"
  add_foreign_key "grade_categories", "students"
  add_foreign_key "klasses", "teachers"
  add_foreign_key "parents", "admins"
  add_foreign_key "students", "parents"
  add_foreign_key "teachers", "admins"
end
