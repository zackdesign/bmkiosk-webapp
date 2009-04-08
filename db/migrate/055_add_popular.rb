class AddPopular < ActiveRecord::Migration
  def self.up
    add_column :phones, :popularity, :int, :default => 0
    add_column :accessories, :popularity, :int, :default => 0
  end

  def self.down
    remove_column :phones, :popularity
    remove_column :accessories, :popularity
  end
end
