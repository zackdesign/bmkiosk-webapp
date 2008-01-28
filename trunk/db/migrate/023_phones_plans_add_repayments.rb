class PhonesPlansAddRepayments < ActiveRecord::Migration
  def self.up
    add_column :phones_plans, :mro, :text
  end

  def self.down
    remove_column :phones_plans, :mro
  end
end