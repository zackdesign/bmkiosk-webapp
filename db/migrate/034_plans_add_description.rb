class PlansAddDescription < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE `plans` ADD `description` TEXT NOT NULL AFTER `categories`"
  end

  def self.down
    remove_column :plans, :description
  end
end
