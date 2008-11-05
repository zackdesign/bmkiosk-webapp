class CreateKiosks < ActiveRecord::Migration
  def self.up
    create_table :kiosks do |t|
      t.column :phone_id, :integer, :null => false
      t.column :kiosk, :integer, :null => false
    end
    remove_column :kiosks, :id
  end

  def self.down
    drop_table :kiosks
  end
end
