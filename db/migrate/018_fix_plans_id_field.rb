class FixPlansIdField < ActiveRecord::Migration
  def self.up
    change_column :plans, :id, :integer, {:auto_increment => true, :null => false }
    execute " ALTER TABLE `plans` CHANGE `id` `id` INT( 24 ) NOT NULL  AUTO_INCREMENT "
  end

  def self.down
    change_column :plans, :id, :integer
    execute " ALTER TABLE `plans` CHANGE `id` `id` INT( 24 ) NOT NULL  "
  end
end
