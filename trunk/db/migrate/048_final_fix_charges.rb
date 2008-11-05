class FinalFixCharges < ActiveRecord::Migration
  def self.up
    drop_table :charges
    drop_table :charge_columns
    drop_table :charge_rows
    drop_table :charges_plans
    
    create_table :charges do |t|
          t.column :name,         :text
          t.column :created_at,   :timestamp
          t.column :updated_at,   :timestamp
    end
    
    create_table :charge_values do |t|
              t.column :value,         :text
              t.column :charge_id, :integer
              t.column :plan_id, :integer
              t.column :plan_group_id, :integer
              t.column :created_at,   :timestamp
              t.column :updated_at,   :timestamp
    end
    
  end

  def self.down
    drop_table :charges
    drop_table :charge_values
    
    execute "CREATE TABLE IF NOT EXISTS `charge_rows` (
  `id` int(11) NOT NULL auto_increment,
  `charge_column_id` int(24) default NULL,
  `name` text,
  `value` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1"

    execute "CREATE TABLE IF NOT EXISTS `charge_columns` (
  `id` int(11) NOT NULL auto_increment,
  `charges_id` int(24) default NULL,
  `name` text,
  `value` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1"


    execute "CREATE TABLE IF NOT EXISTS `charges` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) default NULL,
  `discontinued` tinyint(1) default '0',
  `description` text,
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1"

    execute "CREATE TABLE IF NOT EXISTS `charges_plans` (
  `charge_id` int(11) NOT NULL,
  `plan_id` int(11) NOT NULL,
  KEY `index_charges_plans_on_charge_id_and_plan_id` (`charge_id`,`plan_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1"
  end
end

