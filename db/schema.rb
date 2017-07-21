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

ActiveRecord::Schema.define(version: 20170716221442) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "first_name"
    t.string   "last_name"
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "attribute_items", force: :cascade do |t|
    t.integer  "product_id",                       null: false
    t.integer  "company_id"
    t.integer  "kind",             default: 0
    t.json     "data",             default: {}
    t.decimal  "base_price",       default: "0.0"
    t.integer  "base_quantity",    default: 1
    t.decimal  "additional_price", default: "0.0"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "parent_id"
    t.index ["product_id"], name: "index_attribute_items_on_product_id", using: :btree
  end

  create_table "calendar_items", force: :cascade do |t|
    t.integer  "photographer_id",                          null: false
    t.datetime "unavailable_from",                         null: false
    t.datetime "unavailable_to",                           null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.integer  "kind",                     default: 0
    t.string   "google_calendar_event_id"
    t.string   "description"
    t.string   "title"
    t.boolean  "internal",                 default: false
    t.integer  "order_id"
    t.index ["order_id"], name: "index_calendar_items_on_order_id", using: :btree
    t.index ["photographer_id"], name: "index_calendar_items_on_photographer_id", using: :btree
  end

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "office_branch"
    t.string   "website"
    t.string   "logo"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "status"
  end

  create_table "contact_requests", force: :cascade do |t|
    t.string   "sender_email"
    t.text     "body"
    t.string   "subject"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  create_table "coupons", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.integer  "max_uses"
    t.integer  "max_uses_per_user"
    t.date     "start_date"
    t.date     "expiration_date"
    t.decimal  "minimum_purchase"
    t.integer  "discount_type",      default: 0
    t.decimal  "discount_amount"
    t.integer  "status",             default: 0
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.integer  "track_coupon_usage", default: 0
    t.integer  "company_id"
  end

  create_table "coupons_customers", id: false, force: :cascade do |t|
    t.integer "customer_id"
    t.integer "coupon_id"
    t.index ["coupon_id"], name: "index_coupons_customers_on_coupon_id", using: :btree
    t.index ["customer_id"], name: "index_coupons_customers_on_customer_id", using: :btree
  end

  create_table "credit_cards", force: :cascade do |t|
    t.string   "auth_code",      null: false
    t.string   "trans_id",       null: false
    t.string   "account_number", null: false
    t.string   "account_type",   null: false
    t.integer  "customer_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.index ["customer_id"], name: "index_credit_cards_on_customer_id", using: :btree
  end

  create_table "customers", force: :cascade do |t|
    t.string   "full_name"
    t.string   "mobile"
    t.string   "website"
    t.string   "avatar"
    t.integer  "company_id"
    t.string   "second_email"
    t.string   "third_email"
    t.integer  "role",                         default: 0
    t.datetime "created_at",                                null: false
    t.datetime "updated_at",                                null: false
    t.string   "email",                        default: "", null: false
    t.string   "encrypted_password",           default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "status",                       default: 0
    t.string   "authorize_authorization_code"
    t.string   "authorize_transaction_id"
    t.index ["email"], name: "index_customers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_customers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "order_attributes", force: :cascade do |t|
    t.integer  "order_id",                          null: false
    t.integer  "quantity",          default: 1,     null: false
    t.decimal  "price",             default: "0.0", null: false
    t.string   "name",                              null: false
    t.json     "data",              default: {},    null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "estimated_time"
    t.integer  "attribute_item_id"
    t.string   "document"
    t.index ["attribute_item_id"], name: "index_order_attributes_on_attribute_item_id", using: :btree
    t.index ["order_id"], name: "index_order_attributes_on_order_id", using: :btree
  end

  create_table "orders", force: :cascade do |t|
    t.integer  "status",              default: 0
    t.string   "address"
    t.string   "second_address"
    t.string   "city"
    t.string   "state"
    t.string   "zip_code"
    t.decimal  "listing_price"
    t.float    "square_footage"
    t.float    "number_of_beds"
    t.float    "number_of_baths"
    t.text     "listing_description"
    t.text     "additional_notes"
    t.integer  "photographer_id"
    t.integer  "customer_id"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "step",                default: 0,     null: false
    t.integer  "active_step"
    t.integer  "current_step"
    t.datetime "event_started_at"
    t.integer  "coupon_id"
    t.decimal  "travel_costs",        default: "0.0", null: false
    t.text     "special_request"
    t.index ["customer_id"], name: "index_orders_on_customer_id", using: :btree
    t.index ["photographer_id"], name: "index_orders_on_photographer_id", using: :btree
  end

  create_table "orders_products", id: false, force: :cascade do |t|
    t.integer "order_id"
    t.integer "product_id"
    t.integer "quantity",   default: 1
    t.index ["order_id"], name: "index_orders_products_on_order_id", using: :btree
    t.index ["product_id"], name: "index_orders_products_on_product_id", using: :btree
  end

  create_table "photographer_attachments", force: :cascade do |t|
    t.integer  "photographer_id",         null: false
    t.integer  "order_attribute_id",      null: false
    t.string   "attachment",              null: false
    t.string   "attachment_content_type", null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["order_attribute_id"], name: "index_photographer_attachments_on_order_attribute_id", using: :btree
    t.index ["photographer_id"], name: "index_photographer_attachments_on_photographer_id", using: :btree
  end

  create_table "photographer_attributes", force: :cascade do |t|
    t.integer  "photographer_id",                   null: false
    t.integer  "attribute_item_id",                 null: false
    t.datetime "created_at",                        null: false
    t.datetime "updated_at",                        null: false
    t.integer  "default_time"
    t.integer  "extra_time"
    t.decimal  "rate"
    t.decimal  "additional_rate",   default: "0.0"
    t.index ["attribute_item_id"], name: "index_photographer_attributes_on_attribute_item_id", using: :btree
    t.index ["photographer_id"], name: "index_photographer_attributes_on_photographer_id", using: :btree
  end

  create_table "photographers", force: :cascade do |t|
    t.string   "avatar"
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.integer  "status",                            default: 0
    t.string   "first_name"
    t.string   "last_name"
    t.string   "google_access_token"
    t.string   "google_refresh_token"
    t.string   "provider"
    t.string   "uid"
    t.bigint   "google_expires_at"
    t.time     "start_work_at"
    t.time     "end_work_at"
    t.string   "default_time_zone"
    t.string   "google_resource_id"
    t.string   "phone",                  limit: 50
    t.index ["email"], name: "index_photographers_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_photographers_on_reset_password_token", unique: true, using: :btree
  end

  create_table "photographers_zip_codes", id: false, force: :cascade do |t|
    t.integer "photographer_id"
    t.integer "zip_code_id"
    t.index ["photographer_id"], name: "index_photographers_zip_codes_on_photographer_id", using: :btree
    t.index ["zip_code_id"], name: "index_photographers_zip_codes_on_zip_code_id", using: :btree
  end

  create_table "products", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "sku"
    t.integer  "status",      default: 0
    t.integer  "category_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.string   "image"
    t.index ["category_id"], name: "index_products_on_category_id", using: :btree
  end

  create_table "zip_codes", force: :cascade do |t|
    t.string   "value",      null: false
    t.string   "state_code", null: false
    t.string   "state_name"
    t.string   "city"
    t.string   "time_zone"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "attribute_items", "products"
  add_foreign_key "calendar_items", "orders", on_delete: :cascade
  add_foreign_key "credit_cards", "customers"
  add_foreign_key "order_attributes", "attribute_items"
  add_foreign_key "order_attributes", "orders"
  add_foreign_key "photographer_attachments", "order_attributes"
  add_foreign_key "photographer_attachments", "photographers"
  add_foreign_key "photographer_attributes", "attribute_items"
  add_foreign_key "photographer_attributes", "photographers"
end
