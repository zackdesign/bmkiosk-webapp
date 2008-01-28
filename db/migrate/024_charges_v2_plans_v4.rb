class ChargesV2PlansV4 < ActiveRecord::Migration
  def self.up
    # Changes to Charges, Charge_Types, and Charge_Type_Fields tables
    rename_column :charges, :field_id, :charge_type_field

    # Change to Plans table
    add_column :plans, :charge_type, :integer
  end

  def self.down
    # Changes to Charges, Charge_Types, and Charge_Type_Fields tables
    #rename_column :charges, :charge_type_field, :field_id

    # Change to Plans table
    remove_column :plans, :charge_type
  end
end
