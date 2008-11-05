class FixCharges < ActiveRecord::Migration
  def self.up
    execute "  ALTER TABLE `charge_columns` CHANGE `charge_row_id` `charge_column_id` INT( 24 ) NULL DEFAULT NULL "
    execute "  RENAME TABLE `charge_columns`  TO `charge_columns1` "
    execute "  RENAME TABLE `charge_rows`  TO `charge_columns` "
    execute "  RENAME TABLE `charge_columns1`  TO `charge_rows` "
  end

  def self.down
    execute "  RENAME TABLE `charge_rows`  TO `charge_rows1` "
    execute "  RENAME TABLE `charge_columns`  TO `charge_rows` "
    execute "  RENAME TABLE `charge_rows1`  TO `charge_columns` "
    execute "  ALTER TABLE `charge_columns` CHANGE `charge_column_id` `charge_row_id` INT( 24 ) NULL DEFAULT NULL "
  end
end
