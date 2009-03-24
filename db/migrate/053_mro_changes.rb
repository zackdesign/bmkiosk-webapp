class MroChanges < ActiveRecord::Migration
  def self.up
    add_column :plan_groups, :applies_all_phones, :boolean
  end

  def self.down
    remove_column :plan_groups, :applies_all
  end
end
