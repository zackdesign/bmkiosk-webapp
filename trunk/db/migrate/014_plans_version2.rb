class PlansVersion2 < ActiveRecord::Migration
  def self.up
    change_column :plans, :id, :integer, :limit => 24
    change_column :plans, :name, :string
    execute "ALTER TABLE plans ADD COLUMN categories SET('consumer','business','corporate') NOT NULL DEFAULT 'consumer' AFTER name"
    rename_column :plans, :flexi_code, :code
    rename_column :plans, :contract, :period
    execute "ALTER TABLE plans MODIFY COLUMN price DECIMAL(9,2) NULL DEFAULT NULL"
    rename_column :plans, :price, :handset_cost
    add_column :plans, :handset, :integer, :limit => 24
    add_column :plans, :plan_group, :integer,:limit => 24
    execute "ALTER TABLE plans MODIFY COLUMN flexi_price DECIMAL(9,2) NULL DEFAULT NULL"
    rename_column :plans, :flexi_price, :offer_price
    change_column :plans, :offer, :string
    remove_column :plans, :base_etc
    execute "ALTER TABLE plans ADD COLUMN repayments DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    change_column :plans, :id, :integer
    change_column :plans, :name, :text
    #remove_column :plans, :categories
    #rename_column :plans, :code, :flexi_code
    #rename_column :plans, :period, :contract
    #rename_column :plans, :handset_cost, :price
    change_column :plans, :price, :integer
    remove_column :plans, :handset
    remove_column :plans, :plan_group
    rename_column :plans, :offer_price, :flexi_price
    change_column :plans, :flexi_price, :integer
    change_column :plans, :offer, :text
    add_column :plans, :base_etc, :integer
    remove_column :plans, :repayments
  end
end
