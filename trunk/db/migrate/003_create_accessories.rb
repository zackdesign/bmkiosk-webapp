class CreateAccessories < ActiveRecord::Migration
  def self.up
    create_table :accessories do |t|
      t.column :name,         :text
      t.column :description,  :text
      t.column :price,        :integer
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
      t.column :outofstock,   :boolean, :default => false
      t.column :discontinued, :boolean, :default => false
    end
  end

  def self.down
    drop_table :accessories
  end
end
