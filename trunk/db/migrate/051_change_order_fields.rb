class ChangeOrderFields < ActiveRecord::Migration
  def self.up
    remove_column :orders, :pay_type
    rename_column :orders, :address, :message
    add_column :orders, :phone_no, :string
  end

  def self.down
    add_column :orders, :pay_type, :string, :limit => 10
    rename_column :orders, :message, :address
    remove_column :orders, :phone_no
  end
end
