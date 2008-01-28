class ChangeAccessoryPriceToFloat < ActiveRecord::Migration
  def self.up
    change_column :accessories, :price, :float
  end

  def self.down
    change_column :accessories, :price, :integer
  end
end
