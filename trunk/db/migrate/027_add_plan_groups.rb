class AddPlanGroups < ActiveRecord::Migration
  def self.up
    execute "ALTER TABLE plan_groups MODIFY COLUMN categories SET('consumer','business','corporate','government') NOT NULL DEFAULT 'consumer'"
    execute "ALTER TABLE plans MODIFY COLUMN categories SET('consumer','business','corporate','government') NOT NULL DEFAULT 'consumer'"
  end

  def self.down
    execute "ALTER TABLE plan_groups MODIFY COLUMN categories SET('consumer','business','corporate') NOT NULL DEFAULT 'consumer'"
    execute "ALTER TABLE plans MODIFY COLUMN categories SET('consumer','business','corporate') NOT NULL DEFAULT 'consumer'"
  end
end
