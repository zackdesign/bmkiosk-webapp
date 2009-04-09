class ChangeOrderFields2 < ActiveRecord::Migration
  def self.up
    add_column :orders, :attention, :string
    add_column :orders, :purchase_number, :string
    add_column :orders, :billing_type, :string
    add_column :orders, :billing_address, :string
    add_column :orders, :shipping_address, :string
  end

  def self.down
    remove_column :orders, :attention
    remove_column :orders, :purchase_number
    remove_column :orders, :billing_type
    remove_column :orders, :billing_address
    remove_column :orders, :shipping_address
  end
end
