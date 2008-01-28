class CreatePlans < ActiveRecord::Migration
  def self.up
    create_table :plans do |t|
      t.column :name,         :text
      t.column :comments,     :text
      t.column :price,        :integer
      t.column :flexi_code,   :text
      t.column :flexi_price,  :integer
      t.column :base_etc,     :integer
      t.column :offer,        :text
      t.column :contract,     :integer
      t.column :created_at,   :timestamp
      t.column :updated_at,   :timestamp
      t.column :discontinued, :boolean, :default => false
    end
  end

  def self.down
    drop_table :plans
  end
end
