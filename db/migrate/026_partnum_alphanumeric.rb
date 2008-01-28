class PartnumAlphanumeric < ActiveRecord::Migration
  def self.up
    change_column :phones, :partnum, :string
	change_column :accessories, :partnum, :string
  end

  def self.down
    change_column :phones, :partnum, :integer
	change_column :accessories, :partnum, :integer
  end
end
