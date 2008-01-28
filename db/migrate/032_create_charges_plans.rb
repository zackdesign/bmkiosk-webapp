class CreateChargesPlans < ActiveRecord::Migration
  def self.up
    create_table :charges_plans, :id => false do |t|
      t.column :charge_id, :integer, :null => false
      t.column :plan_id, :integer, :null => false
    end
    
    # Indexes are important for performance if join tables grow big
    add_index :charges_plans, [:charge_id, :plan_id]
  end

  def self.down
    drop_table :charges_plans
  end
end
