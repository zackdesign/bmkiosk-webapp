class FeaturesAddPic < ActiveRecord::Migration
  def self.up
    add_column :features, :picture_name, :string
    add_column :features, :picture_type, :string, :default => "image/jpeg"
    execute "ALTER TABLE features ADD COLUMN picture_data LONGBLOB"
  end

  def self.down
    remove_column :features, :picture_name
    remove_column :features, :picture_type
    remove_column :features, :picture_data
  end
end
