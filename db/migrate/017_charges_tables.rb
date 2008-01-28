class ChargesTables < ActiveRecord::Migration
  def self.up
    create_table :charge_types do |t|
#      t.column :id,             :integer
      t.column :name,           :string
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
      t.column :discontinued,   :boolean, :default => false
    end

    change_column :charge_types, :id, :integer, { :limit => 24 }

    create_table :charge_type_fields do |t|
#      t.column :id,             :integer
      t.column :charge_type_id, :integer, { :limit => 24 }
      t.column :name,           :string
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
      t.column :discontinued,   :boolean, :default => false
    end

    change_column :charge_type_fields, :id, :integer, { :limit => 24 }

    create_table :charges do |t|
#      t.column :id,             :integer
      t.column :plan_id,        :integer, { :limit => 24 }
      t.column :field_id,       :integer, { :limit => 24 }
      t.column :value,          :integer
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
    end

    change_column :charges, :id, :integer, { :limit => 24 }
    execute "ALTER TABLE charges MODIFY COLUMN value DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    drop_table :charge_types
    drop_table :charge_type_fields
    drop_table :charges
  end
end
