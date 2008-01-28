class CreatePlanGroups < ActiveRecord::Migration
  def self.up
    create_table :plan_groups do |t|
      t.column :name,         :string
      t.column :description,  :text
      t.column :categories,   :integer, { :limit => 24 }
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
      t.column :discontinued, :boolean, :default => false
      t.column :active,       :boolean, :default => true
    end
    execute "ALTER TABLE plan_groups MODIFY COLUMN categories SET('consumer','business','corporate') NOT NULL DEFAULT 'consumer'"
  end

  def self.down
    drop_table :plan_groups
  end
end
