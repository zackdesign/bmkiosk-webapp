class AddKioskFields < ActiveRecord::Migration
  def self.up
    add_column :accessories, :plasma, :integer
    add_column :logos, :plasma, :integer
  end

  def self.down
    remove_column :accessories, :plasma
    remove_column :logos, :plasma
  end
end
