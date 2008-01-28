class CreatePhones < ActiveRecord::Migration
  def self.up
    create_table :phones do |t|
      t.column :name,         :text
      t.column :description,  :text
      t.column :outright,     :integer
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
      t.column :outofstock,   :boolean, :default => false
      t.column :discontinued, :boolean, :default => false
    end
  end

  def self.down
    drop_table :phones
  end
end
