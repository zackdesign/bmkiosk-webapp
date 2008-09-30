class AccessoriesAddFields2 < ActiveRecord::Migration
  def self.up
    add_column :accessories, :govt_price, :float
    execute "ALTER TABLE accessories MODIFY COLUMN govt_price DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    remove_column :accessories, :govt_price
  end
end
