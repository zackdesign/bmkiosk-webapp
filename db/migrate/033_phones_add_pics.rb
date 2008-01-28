class PhonesAddPics < ActiveRecord::Migration
  def self.up
    add_column :phones, :picture2_name, :string
    add_column :phones, :picture2_type, :string, :default => "image/jpeg"
    execute "ALTER TABLE phones ADD COLUMN picture2_data LONGBLOB"
    add_column :phones, :picture3_name, :string
    add_column :phones, :picture3_type, :string, :default => "image/jpeg"
    execute "ALTER TABLE phones ADD COLUMN picture3_data LONGBLOB"
  end

  def self.down
    remove_column :phones, :picture2_name
    remove_column :phones, :picture2_type
    remove_column :phones, :picture2_data
    remove_column :phones, :picture3_name
    remove_column :phones, :picture3_type
    remove_column :phones, :picture3_data
  end
end
