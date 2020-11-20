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

ActiveRecord::Schema.define(version: 2020_11_20_050820) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "orderitems", force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity"
    t.integer "price"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "order_status", default: "pending"
    t.boolean "shipped", default: false
    t.boolean "cancelled", default: false
  end

  create_table "orders", force: :cascade do |t|
    t.integer "order_item_id"
    t.string "name"
    t.string "email"
    t.string "mailing_address"
    t.string "cc_name"
    t.bigint "cc_number"
    t.string "cc_exp_date"
    t.integer "billing_zip_code"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.integer "stock"
    t.integer "price"
    t.string "description"
    t.integer "user_id"
    t.string "photo_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "retired", default: false
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "uid"
    t.string "provider"
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
