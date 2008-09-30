class AddBrandToAccessories < ActiveRecord::Migration
  def self.up
    add_column :accessories, :brand, :string, :default => ''
  end

  def self.down
    remove_column :accessories, :brand
  end
end
