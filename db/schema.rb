ActiveRecord::Schema[7.0].define(version: 2022_09_17_070431) do
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
    t.integer "revenue"
    t.integer "budget"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "profit"
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
