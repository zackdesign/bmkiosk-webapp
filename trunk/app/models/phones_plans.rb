# == Schema Information
# Schema version: 26
#
# Table name: phones_plans
#
#  plan_id      :integer(24)   default(0)
#  phone_id     :integer(24)   default(0)
#  handset_cost :decimal(9, 2) 
#  mro          :text          
#  id           :integer(11)   not null, primary key
#

class PhonesPlans < ActiveRecord::Base
end
