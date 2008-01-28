class PlansAddIncrement < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `plans` CHANGE `id` `id` INT( 24 ) NOT NULL AUTO_INCREMENT"
  end

  def self.down
  end
end
