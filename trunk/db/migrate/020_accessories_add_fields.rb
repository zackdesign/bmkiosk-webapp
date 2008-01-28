class AccessoriesAddFields < ActiveRecord::Migration
  def self.up
    add_column :accessories, :buy_price, :float
	add_column :accessories, :supplier, :text
	add_column :accessories, :partnum, :integer
	add_column :accessories, :corp_price, :float
	
	execute "ALTER TABLE accessories MODIFY COLUMN buy_price DECIMAL(9,2) NULL DEFAULT NULL"
	execute "ALTER TABLE accessories MODIFY COLUMN corp_price DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    remove_column :accessories, :buy_price
	remove_column :accessories, :supplier
	remove_column :accessories, :partnum
	remove_column :accessories, :corp_price
  end
end
