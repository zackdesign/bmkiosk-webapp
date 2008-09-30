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

    change_column :charge_types, :id, :integer
    execute " ALTER TABLE `charge_types` CHANGE `id` `id` INT( 24 ) NOT NULL  "

    create_table :charge_type_fields do |t|
#      t.column :id,             :integer
      t.column :charge_type_id, :integer
      t.column :name,           :string
      t.column :description,    :text
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
      t.column :discontinued,   :boolean, :default => false
    end
    
    change_column :charge_type_fields, :id, :integer
    execute " ALTER TABLE `charge_type_fields` CHANGE `id` `id` INT( 24 ) NOT NULL"
    execute " ALTER TABLE `charge_type_fields` CHANGE `charge_type_id` `charge_type_id` INT( 24 ) NOT NULL  "

    create_table :charges do |t|
#      t.column :id,             :integer
      t.column :plan_id,        :integer
      t.column :field_id,       :integer
      t.column :value,          :integer
      t.column :created_at,     :timestamp
      t.column :updated_at,     :timestamp
    end

    change_column :charges, :id, :integer
    execute " ALTER TABLE `charges` CHANGE `id` `id` INT( 24 ) NOT NULL"
    execute "  ALTER TABLE `charges` CHANGE `plan_id` `plan_id` INT( 24 ) NOT NULL"
    execute " ALTER TABLE `charges` CHANGE `field_id` `field_id` INT( 24 ) NOT NULL"
    execute "ALTER TABLE charges MODIFY COLUMN value DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    # Changed to something else further on...
    drop_table :charge_types
    drop_table :charge_type_fields
    drop_table :charges
  end
end
