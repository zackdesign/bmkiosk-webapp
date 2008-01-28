class PlansVersion3 < ActiveRecord::Migration
  def self.up
    change_column :phones_plans, :plan_id, :integer, { :limit => 24, :default => 0 }
    change_column :phones_plans, :phone_id, :integer, { :limit => 24, :default => 0 }
#    change_column :phones_plans, :offer_price, :float
    execute "ALTER TABLE phones_plans MODIFY COLUMN offer_price DECIMAL(9,2) NOT NULL DEFAULT 0" 
    rename_column :phones_plans, :offer_price, :handset_cost
  end

  def self.down
    change_column :phones_plans, :plan_id, :integer
    change_column :phones_plans, :phone_id, :integer
    rename_column :phones_plans, :handset_cost, :offer_price
    change_column :phones_plans, :offer_price, :integer
  end
end
