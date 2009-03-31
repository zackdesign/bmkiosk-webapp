# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 53) do

  create_table "accessories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",                              :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "outofstock",                                                       :default => false
    t.boolean  "discontinued",                                                     :default => false
    t.string   "picture_name"
    t.string   "picture_type",                                                     :default => "image/jpeg"
    t.binary   "picture_data", :limit => 2147483647
    t.boolean  "active",                                                           :default => true
    t.decimal  "buy_price",                          :precision => 9, :scale => 2
    t.text     "supplier"
    t.string   "partnum"
    t.decimal  "corp_price",                         :precision => 9, :scale => 2
    t.decimal  "govt_price",                         :precision => 9, :scale => 2
    t.string   "brand",                                                            :default => ""
    t.integer  "plasma"
  end

  create_table "charge_values", :force => true do |t|
    t.text     "value"
    t.integer  "charge_id"
    t.integer  "plan_id"
    t.integer  "plan_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                             :default => true
    t.string   "picture_name"
    t.string   "picture_type",                       :default => "image/jpeg"
    t.binary   "picture_data", :limit => 2147483647
  end

  create_table "kiosks", :id => false, :force => true do |t|
    t.integer "phone_id", :null => false
    t.integer "kiosk",    :null => false
  end

  create_table "line_items", :force => true do |t|
    t.integer "product_id",                                :null => false
    t.integer "order_id",                                  :null => false
    t.integer "quantity",                                  :null => false
    t.decimal "total_price", :precision => 8, :scale => 2, :null => false
  end

  add_index "line_items", ["product_id"], :name => "fk_line_item_products"
  add_index "line_items", ["order_id"], :name => "fk_line_item_orders"

  create_table "local_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "local_sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "local_sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "logos", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_name"
    t.string   "picture_type",                       :default => "image/jpeg"
    t.binary   "picture_data", :limit => 2147483647
    t.integer  "plasma"
  end

  create_table "options", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string "name"
    t.text   "message"
    t.string "email"
    t.string "phone_no"
  end

  create_table "phones", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "outright",                            :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "outofstock",                                                        :default => false
    t.boolean  "discontinued",                                                      :default => false
    t.string   "picture_name"
    t.string   "picture_type",                                                      :default => "image/jpeg"
    t.binary   "picture_data",  :limit => 2147483647
    t.decimal  "buy_price",                           :precision => 9, :scale => 2
    t.text     "supplier"
    t.string   "partnum"
    t.decimal  "corp_price",                          :precision => 9, :scale => 2
    t.decimal  "gov_price",                           :precision => 9, :scale => 2
    t.text     "brand"
    t.text     "network"
    t.decimal  "prepaid",                             :precision => 9, :scale => 2
    t.string   "picture2_name"
    t.string   "picture2_type",                                                     :default => "image/jpeg"
    t.binary   "picture2_data", :limit => 2147483647
    t.string   "picture3_name"
    t.string   "picture3_type",                                                     :default => "image/jpeg"
    t.binary   "picture3_data", :limit => 2147483647
    t.boolean  "coming_soon"
  end

  create_table "phones_accessories", :id => false, :force => true do |t|
    t.integer "phone_id",     :null => false
    t.integer "accessory_id", :null => false
  end

  add_index "phones_accessories", ["phone_id", "accessory_id"], :name => "index_phones_accessories_on_phone_id_and_accessory_id"

  create_table "phones_features", :id => false, :force => true do |t|
    t.integer "phone_id",   :null => false
    t.integer "feature_id", :null => false
  end

  add_index "phones_features", ["phone_id", "feature_id"], :name => "index_phones_features_on_phone_id_and_feature_id"

  create_table "phones_plans", :force => true do |t|
    t.integer "plan_id",                                    :default => 0
    t.integer "phone_id",                                   :default => 0
    t.decimal "handset_cost", :precision => 9, :scale => 2
  end

  add_index "phones_plans", ["phone_id", "plan_id"], :name => "index_phones_plans_on_phone_id_and_plan_id"

# Could not dump table "plan_groups" because of following StandardError
#   Unknown type 'set('consumer','business','corporate','government')' for column 'categories'

# Could not dump table "plans" because of following StandardError
#   Unknown type 'set('consumer','business','corporate','government')' for column 'categories'

  create_table "plans_options", :id => false, :force => true do |t|
    t.integer "plan_id",   :null => false
    t.integer "option_id", :null => false
  end

  add_index "plans_options", ["plan_id", "option_id"], :name => "index_plans_options_on_plan_id_and_option_id"

  create_table "products", :force => true do |t|
    t.string  "title"
    t.text    "description"
    t.string  "image_url"
    t.decimal "price",       :precision => 8, :scale => 2, :default => 0.0
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "user_values", :id => false, :force => true do |t|
    t.text    "name",  :null => false
    t.boolean "value"
  end

  create_table "users", :force => true do |t|
    t.string "name"
    t.string "hashed_password"
    t.string "salt"
    t.string "usertype"
  end

  create_table "web_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "web_sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "web_sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

end
