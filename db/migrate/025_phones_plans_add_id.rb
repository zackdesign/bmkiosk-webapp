class PhonesPlansAddId < ActiveRecord::Migration
  def self.up
    add_column :phones_plans, :id, :primary_key, { :null => false, :auto_increment => true }
  end

  def self.down
    remove_column :phones_plans, :id
  end
end
