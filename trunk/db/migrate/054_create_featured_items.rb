class CreateFeaturedItems < ActiveRecord::Migration
  def self.up
    create_table :featured_phones do |t|
      t.column :phone_id, :integer, :null => false
    end
    remove_column :featured_phones, :id
    create_table :featured_accessories do |t|
      t.column :accessory_id, :integer, :null => false
      t.column :atype, :text, :null => false
    end
    remove_column :featured_accessories, :id
  end

  def self.down
    drop_table :featured_phones
    drop_table :featured_accessories
  end
end
