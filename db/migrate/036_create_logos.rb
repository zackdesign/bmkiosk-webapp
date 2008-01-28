class CreateLogos < ActiveRecord::Migration
  def self.up
    create_table :logos do |t|
      t.column :name,         :text
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
      t.column :picture_name, :string
      t.column :picture_type, :string, :default => "image/jpeg"
    end
    execute "ALTER TABLE logos ADD COLUMN picture_data LONGBLOB"
  end

  def self.down
    drop_table :logos
  end
end
