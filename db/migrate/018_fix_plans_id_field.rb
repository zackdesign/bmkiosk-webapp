class FixPlansIdField < ActiveRecord::Migration
  def self.up
    change_column :plans, :id, :integer, { :limit => 24, :auto_increment => true, :null => false }
  end

  def self.down
    change_column :plans, :id, :integer, { :limit => 24 }
  end
end
