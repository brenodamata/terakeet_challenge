# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160324162418) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authors", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_format_types", force: :cascade do |t|
    t.string   "name"
    t.boolean  "physical"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "book_formats", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "book_format_type_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "book_formats", ["book_format_type_id"], name: "index_book_formats_on_book_format_type_id", using: :btree
  add_index "book_formats", ["book_id"], name: "index_book_formats_on_book_id", using: :btree

  create_table "book_reviews", force: :cascade do |t|
    t.integer  "book_id"
    t.integer  "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "book_reviews", ["book_id"], name: "index_book_reviews_on_book_id", using: :btree

  create_table "books", force: :cascade do |t|
    t.string   "title"
    t.integer  "publisher_id"
    t.integer  "author_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "genre_id"
  end

  add_index "books", ["author_id"], name: "index_books_on_author_id", using: :btree
  add_index "books", ["genre_id"], name: "index_books_on_genre_id", using: :btree
  add_index "books", ["publisher_id"], name: "index_books_on_publisher_id", using: :btree

  create_table "genres", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "publishers", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "book_formats", "book_format_types"
  add_foreign_key "book_formats", "books"
  add_foreign_key "book_reviews", "books"
  add_foreign_key "books", "authors"
  add_foreign_key "books", "publishers"
end
