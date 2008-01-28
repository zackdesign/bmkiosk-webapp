class ChangeFeatureNameToString < ActiveRecord::Migration
  def self.up
    change_column :features, :name, :string
  end

  def self.down
    change_column :features, :name, :text
  end
end
