class PhonesFeatures < ActiveRecord::Migration
  def self.up
    create_table :phones_features, :id => false do |t|
      t.column :phone_id, :integer, :null => false
      t.column :feature_id, :integer, :null => false
    end
    
    # Indexes are important for performance if join tables grow big
    add_index :phones_features, [:phone_id, :feature_id]
  end

  def self.down
    drop_table :phones_features
  end
end
