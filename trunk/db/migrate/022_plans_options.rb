class PlansOptions < ActiveRecord::Migration
  def self.up
    create_table :plans_options, :id => false do |t|
      t.column :plan_id, :integer, :null => false
      t.column :option_id, :integer, :null => false
    end
    
	change_column :options, :id, :integer, { :limit => 24 }
	
    # Indexes are important for performance if join tables grow big
    add_index :plans_options, [:plan_id, :option_id]
  end

  def self.down
    drop_table :plans_options
  end
end
