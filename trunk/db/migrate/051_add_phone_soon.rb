class AddPhoneSoon < ActiveRecord::Migration
  def self.up
    add_column :phones, :coming_soon, :boolean
  end

  def self.down
    remove_column :phones, :coming_soon
  end
end
