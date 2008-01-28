class ChangePlanPeriod < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE plans MODIFY COLUMN period TEXT NULL DEFAULT NULL"
  end

  def self.down
    execute "ALTER TABLE plans MODIFY COLUMN period INTEGER NULL DEFAULT NULL"
  end
end
