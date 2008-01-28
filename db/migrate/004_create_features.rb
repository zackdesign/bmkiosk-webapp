class CreateFeatures < ActiveRecord::Migration
  def self.up
    create_table :features do |t|
      t.column :name,         :text
      t.column :description,  :text
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
    end
  end

  def self.down
    drop_table :features
  end
end
