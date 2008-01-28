class AccessoriesAddActiveFlagForArchive < ActiveRecord::Migration
  def self.up
    add_column :accessories, :active, :boolean, :default => true
  end

  def self.down
    remove_column :accessories, :active
  end
end
