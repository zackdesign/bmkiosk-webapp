class Morephonesinfo < ActiveRecord::Migration
  def self.up
    remove_column :phones_plans, :mro
    add_column :phones, :brand, :text
    add_column :phones, :network, :text
    add_column :phones, :prepaid, :float
    execute "ALTER TABLE phones MODIFY COLUMN prepaid DECIMAL(9,2) NULL DEFAULT NULL"
  end

  def self.down
    add_column :phones_plans, :mro, :text
    remove_column :phones, :prepaid
    remove_column :phones, :brand
    remove_column :phones, :network
  end
end
