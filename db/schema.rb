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

ActiveRecord::Schema[7.1].define(version: 2024_04_08_061947) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "bookings", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "product_id", null: false
    t.bigint "order_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", default: "0.0", null: false
    t.decimal "amount", default: "0.0", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((code)::text)", name: "index_bookings_on_lower_code", unique: true
    t.index ["customer_id"], name: "index_bookings_on_customer_id"
    t.index ["order_id"], name: "index_bookings_on_order_id"
    t.index ["product_id"], name: "index_bookings_on_product_id"
  end

  create_table "cart_items", force: :cascade do |t|
    t.bigint "cart_id", null: false
    t.bigint "product_id", null: false
    t.integer "quantity", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
  end

  create_table "carts", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_carts_on_customer_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "full_name", null: false
    t.string "phone", null: false
    t.string "phone_country_code", null: false
    t.integer "password_reset_attempts", default: 0
    t.datetime "reset_password_expires_at"
    t.string "reset_password_token"
    t.string "password_digest", null: false
    t.string "email", null: false
    t.boolean "email_verified", default: false, null: false
    t.string "email_verification_token"
    t.boolean "phone_verified", default: false, null: false
    t.integer "phone_otp_reset_attempts", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_customers_on_lower_email", unique: true
    t.index ["phone"], name: "index_customers_on_phone", unique: true
  end

  create_table "file_attachments", force: :cascade do |t|
    t.string "type", null: false
    t.string "credits", default: [], array: true
    t.boolean "is_featured", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["type"], name: "index_file_attachments_on_type"
  end

  create_table "orders", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.string "state", null: false
    t.decimal "amount", default: "0.0", null: false
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((code)::text)", name: "index_orders_on_lower_code", unique: true
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["state"], name: "index_orders_on_state"
  end

  create_table "otps", force: :cascade do |t|
    t.string "otp_type", null: false
    t.integer "pin", null: false
    t.datetime "sent_at"
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.string "state", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resource_type", "resource_id"], name: "index_otps_on_resource"
  end

  create_table "payments", force: :cascade do |t|
    t.bigint "order_id", null: false
    t.decimal "amount", null: false
    t.string "state", null: false
    t.string "payment_mode"
    t.jsonb "last_event_at"
    t.string "remarks"
    t.string "payment_ref", null: false
    t.string "pg_transaction_id"
    t.string "type", null: false
    t.jsonb "pg_data", default: {}
    t.string "last_pg_error"
    t.string "pg_state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_id"], name: "index_payments_on_order_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "state", null: false
    t.decimal "sticker_price", null: false
    t.decimal "price", null: false
    t.string "category", default: [], null: false, array: true
    t.text "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_products_on_slug", unique: true
    t.index ["state"], name: "index_products_on_state"
  end

  create_table "resource_attachments", force: :cascade do |t|
    t.bigint "file_attachment_id", null: false
    t.string "resource_type", null: false
    t.bigint "resource_id", null: false
    t.integer "position", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_attachment_id"], name: "index_resource_attachments_on_file_attachment_id"
    t.index ["resource_type", "resource_id", "position"], name: "idx_on_resource_type_resource_id_position_b589f59ebb", unique: true
    t.index ["resource_type", "resource_id"], name: "index_resource_attachments_on_resource"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "resource_attachments", "file_attachments"
end
