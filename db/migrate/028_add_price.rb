class AddPrice < ActiveRecord::Migration
  def self.up
    add_column :phones, :gov_price, :float
    execute "ALTER TABLE phones MODIFY COLUMN gov_price DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    remove_column :phones, :gov_price
  end
end
