class Charges < ActiveRecord::Migration
  def self.up
    execute "DROP TABLE IF EXISTS charges"
    execute "DROP TABLE IF EXISTS charge_type_fields"
    execute "DROP TABLE IF EXISTS charge_types"

    create_table :charge_columns do |t|
      t.column :charge_row_id,  :integer, { :limit => 24 }
      t.column :name,           :text
      t.column :value,          :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
    end

    create_table :charge_rows do |t|
      t.column :charges_id,     :integer, { :limit => 24 }
      t.column :name,           :text
      t.column :value,          :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
    end

    create_table :charges do |t|
      t.column :name,           :string
      t.column :discontinued,   :boolean, :default => false
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
    end
    
  end

  def self.down
    drop_table "charge_rows"
    drop_table "charge_columns"
    create_table :charge_types do |t|
#      t.column :id,             :integer
      t.column :name,           :string
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
      t.column :discontinued,   :boolean, :default => false
    end
    create_table :charge_type_fields do |t|
#      t.column :id,             :integer
      t.column :charge_type_id, :integer
      t.column :name,           :string
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
      t.column :discontinued,   :boolean, :default => false
    end
  end
end
