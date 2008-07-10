# == Schema Information
# Schema version: 26
#
# Table name: charges
#
#  id                :integer(24)   default(0), not null, primary key
#  plan_id           :integer(24)   
#  charge_type_field :integer(24)   
#  value             :decimal(9, 2) 
#  created_at        :datetime      
#  updated_at        :datetime      
#

class Charge < ActiveRecord::Base

  belongs_to :plan
  has_many :charge_rows, :foreign_key => "charges_id", :dependent => :destroy

end
