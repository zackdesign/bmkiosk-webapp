class PhonesPlans < ActiveRecord::Migration
  def self.up
    create_table :phones_plans, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :phone_id, :integer, :null => false
      t.column :offer_price, :integer, :default => 0
    end
    
    # Indexes are important for performance if join tables grow big
    add_index :phones_plans, [:phone_id, :plan_id]
  end

  def self.down
    drop_table :phones_plans
  end
end
