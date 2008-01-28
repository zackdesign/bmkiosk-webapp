# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 39) do

  create_table "accessories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "price",        :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "outofstock",                                 :default => false
    t.boolean  "discontinued",                               :default => false
    t.string   "picture_name"
    t.string   "picture_type",                               :default => "image/jpeg"
    t.binary   "picture_data"
    t.boolean  "active",                                     :default => true
    t.decimal  "buy_price",    :precision => 9, :scale => 2
    t.text     "supplier"
    t.string   "partnum"
    t.decimal  "corp_price",   :precision => 9, :scale => 2
    t.decimal  "govt_price",   :precision => 9, :scale => 2
  end

  create_table "charge_columns", :force => true do |t|
    t.integer  "charge_row_id", :limit => 24
    t.text     "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charge_rows", :force => true do |t|
    t.integer  "charges_id", :limit => 24
    t.text     "name"
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges", :force => true do |t|
    t.string   "name"
    t.boolean  "discontinued", :default => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "charges_plans", :id => false, :force => true do |t|
    t.integer "charge_id", :null => false
    t.integer "plan_id",   :null => false
  end

  add_index "charges_plans", ["charge_id", "plan_id"], :name => "index_charges_plans_on_charge_id_and_plan_id"

  create_table "features", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",       :default => true
    t.string   "picture_name"
    t.string   "picture_type", :default => "image/jpeg"
    t.binary   "picture_data"
  end

  create_table "logos", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_name"
    t.string   "picture_type", :default => "image/jpeg"
    t.binary   "picture_data"
  end

  create_table "options", :force => true do |t|
    t.text     "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "phones", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.decimal  "outright",      :precision => 9, :scale => 2, :default => 0.0,          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "outofstock",                                  :default => false
    t.boolean  "discontinued",                                :default => false
    t.string   "picture_name"
    t.string   "picture_type",                                :default => "image/jpeg"
    t.binary   "picture_data"
    t.decimal  "buy_price",     :precision => 9, :scale => 2
    t.text     "supplier"
    t.string   "partnum"
    t.decimal  "corp_price",    :precision => 9, :scale => 2
    t.decimal  "gov_price",     :precision => 9, :scale => 2
    t.text     "brand"
    t.text     "network"
    t.decimal  "prepaid",       :precision => 9, :scale => 2
    t.string   "picture2_name"
    t.string   "picture2_type",                               :default => "image/jpeg"
    t.binary   "picture2_data"
    t.string   "picture3_name"
    t.string   "picture3_type",                               :default => "image/jpeg"
    t.binary   "picture3_data"
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
    t.integer "plan_id",      :limit => 24,                               :default => 0
    t.integer "phone_id",     :limit => 24,                               :default => 0
    t.decimal "handset_cost",               :precision => 9, :scale => 2
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

end
