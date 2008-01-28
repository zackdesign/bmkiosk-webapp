class PhonesAddFields < ActiveRecord::Migration
  def self.up
    add_column :phones, :buy_price, :float
	add_column :phones, :supplier, :text
	add_column :phones, :partnum, :integer
	add_column :phones, :corp_price, :float
	
	execute "ALTER TABLE phones MODIFY COLUMN buy_price DECIMAL(9,2) NULL DEFAULT NULL"
	execute "ALTER TABLE phones MODIFY COLUMN corp_price DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    remove_column :phones, :buy_price
	remove_column :phones, :supplier
	remove_column :phones, :partnum
	remove_column :phones, :corp_price
  end
end
