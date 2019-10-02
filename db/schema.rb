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

ActiveRecord::Schema.define(version: 2019_10_02_190938) do

  create_table "admins", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "email"
    t.string "password_digest"
  end

  create_table "bookmarks", force: :cascade do |t|
    t.integer "student_id"
    t.string "ISBN"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.string "ISBN"
    t.string "title", limit: 200
    t.string "author", limit: 70
    t.string "language", limit: 20
    t.string "published", limit: 4
    t.string "edition", limit: 4
    t.string "library_id", limit: 10
    t.string "image", limit: 500
    t.string "subject", limit: 100
    t.string "summary", limit: 1000
    t.boolean "specialcollection"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "copies", limit: 6
    t.index ["ISBN"], name: "index_books_on_ISBN", unique: true
  end

  create_table "holds", force: :cascade do |t|
    t.integer "student_id"
    t.string "ISBN"
    t.string "library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "librarians", primary_key: "librarian_id", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "library_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_valid"
    t.index ["email"], name: "index_librarians_on_email", unique: true
  end

  create_table "libraries", primary_key: "library_id", force: :cascade do |t|
    t.string "name", limit: 200
    t.string "university_id", limit: 100
    t.string "location", limit: 300
    t.string "max_days", limit: 10
    t.string "fines", limit: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "logins", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "students", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "educational_level"
    t.string "university_id"
    t.string "maximum_book_limit"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_students_on_email", unique: true
  end

# Could not dump table "transactions" because of following StandardError
#   Unknown type '' for column 'library_id'

  create_table "universities", primary_key: "university_id", force: :cascade do |t|
    t.string "name", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_universities_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password_digest"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_valid"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

end
