class PhonesAccessories < ActiveRecord::Migration
  def self.up
    create_table :phones_accessories, :id => false do |t|
      t.column :phone_id, :integer, :null => false
      t.column :accessory_id, :integer, :null => false
    end
    
    # Indexes are important for performance if join tables grow big
    add_index :phones_accessories, [:phone_id, :accessory_id]
  end

  def self.down
    drop_table :phones_accessories
  end
end
