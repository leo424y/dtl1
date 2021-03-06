# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_22_035622) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "bydays", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_bydays_on_name"
  end

  create_table "domains", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.jsonb "archive", default: "{}", null: false
    t.uuid "node_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_domains_on_created_at"
    t.index ["node_id"], name: "index_domains_on_node_id"
    t.index ["url"], name: "index_domains_on_url"
  end

  create_table "links", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.jsonb "archive", default: "{}", null: false
    t.uuid "post_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_at"], name: "index_links_on_created_at"
    t.index ["post_id"], name: "index_links_on_post_id"
    t.index ["url"], name: "index_links_on_url"
  end

  create_table "nodes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.jsonb "archive", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "domain_id"
    t.index ["domain_id"], name: "index_nodes_on_domain_id"
  end

  create_table "pablos", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "word"
    t.jsonb "archive", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["word"], name: "index_pablos_on_word"
  end

  create_table "pages", force: :cascade do |t|
    t.uuid "uid"
    t.string "uname"
    t.string "pid"
    t.string "ptitle"
    t.string "ptype"
    t.string "pdescription"
    t.string "ptime"
    t.string "mtime"
    t.string "url"
    t.string "platform"
    t.string "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "link"
    t.index ["link"], name: "index_pages_on_link"
    t.index ["mtime"], name: "index_pages_on_mtime"
    t.index ["pid"], name: "index_pages_on_pid"
    t.index ["platform"], name: "index_pages_on_platform"
    t.index ["ptime"], name: "index_pages_on_ptime"
    t.index ["ptitle"], name: "index_pages_on_ptitle"
    t.index ["ptype"], name: "index_pages_on_ptype"
    t.index ["score"], name: "index_pages_on_score"
    t.index ["uid"], name: "index_pages_on_uid"
    t.index ["uname"], name: "index_pages_on_uname"
    t.index ["url"], name: "index_pages_on_url"
  end

  create_table "posts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "url"
    t.string "link"
    t.string "title"
    t.string "date"
    t.string "updated"
    t.jsonb "archive", default: "{}", null: false
    t.uuid "node_id"
    t.decimal "score"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "source"
    t.index ["created_at"], name: "index_posts_on_created_at"
    t.index ["date"], name: "index_posts_on_date"
    t.index ["link"], name: "index_posts_on_link"
    t.index ["node_id"], name: "index_posts_on_node_id"
    t.index ["score"], name: "index_posts_on_score"
    t.index ["source"], name: "index_posts_on_source"
    t.index ["updated"], name: "index_posts_on_updated"
    t.index ["url"], name: "index_posts_on_url"
  end

end
