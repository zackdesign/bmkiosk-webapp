class PhonesChangeNameAndAddPicture < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE phones MODIFY COLUMN outright DECIMAL(9,2) NOT NULL DEFAULT 0" 
    change_column :phones, :name, :string
    add_column :phones, :picture_name, :string
    add_column :phones, :picture_type, :string, :default => "image/jpeg"
    execute "ALTER TABLE phones ADD COLUMN picture_data LONGBLOB"
  end

  def self.down
    change_column :phones, :outright, :integer
    change_column :phones, :name, :text
    remove_column :phones, :picture_name
    remove_column :phones, :picture_type
    remove_column :phones, :picture_data
  end
end
