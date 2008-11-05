class ChangePlansDescription < ActiveRecord::Migration
  def self.up
    execute "   ALTER TABLE `plans` CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL   "
  end

  def self.down
    execute "   ALTER TABLE `plans` CHANGE `description` `description` TEXT CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL   "
  end
end
