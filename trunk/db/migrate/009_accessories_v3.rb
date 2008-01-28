class AccessoriesV3 < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE accessories MODIFY COLUMN price DECIMAL(9,2) NOT NULL DEFAULT 0" 
    change_column :accessories, :name, :string
    add_column :accessories, :picture_name, :string
    add_column :accessories, :picture_type, :string, :default => "image/jpeg"
    execute "ALTER TABLE accessories ADD COLUMN picture_data LONGBLOB"
  end

  def self.down
    change_column :accessories, :price, :float
    change_column :accessories, :name, :text
    remove_column :accessories, :picture_name
    remove_column :accessories, :picture_type
    remove_column :accessories, :picture_data
  end
end
