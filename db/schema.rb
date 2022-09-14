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

ActiveRecord::Schema[7.0].define(version: 2022_09_14_163042) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "directors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_directors_on_name", unique: true
  end

  create_table "directors_entertainments", id: false, force: :cascade do |t|
    t.bigint "director_id", null: false
    t.bigint "entertainment_id", null: false
  end

  create_table "entertainments", force: :cascade do |t|
    t.string "title"
    t.float "ratings"
    t.string "tagline"
    t.datetime "release_date"
    t.string "popularity"
    t.string "type"
    t.string "identifier", null: false
    t.integer "runtime"
    t.string "revenue"
    t.string "budget"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identifier"], name: "index_entertainments_on_identifier", unique: true
  end

  create_table "entertainments_genres", id: false, force: :cascade do |t|
    t.bigint "entertainment_id", null: false
    t.bigint "genre_id", null: false
  end

  create_table "entertainments_producers", id: false, force: :cascade do |t|
    t.bigint "entertainment_id", null: false
    t.bigint "producer_id", null: false
  end

  create_table "entertainments_stars", id: false, force: :cascade do |t|
    t.bigint "star_id", null: false
    t.bigint "entertainment_id", null: false
  end

  create_table "genres", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_genres_on_name", unique: true
  end

  create_table "producers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_producers_on_name", unique: true
  end

  create_table "stars", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_stars_on_name", unique: true
  end

end
