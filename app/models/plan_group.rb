# == Schema Information
# Schema version: 26
#
# Table name: plan_groups
#
#  id           :integer(11)   not null, primary key
#  name         :string(255)   
#  description  :text          
#  categories   :(0)           default("consumer"), not null
#  created_at   :datetime      
#  updated_at   :datetime      
#  discontinued :boolean(1)    
#  active       :boolean(1)    default(TRUE)
#

class PlanGroup < ActiveRecord::Base
  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :plans, :foreign_key => "plan_group"

  def categories_chk=(cat_strs)
    @local_categories_strs = cat_strs
#    breakpoint
    self.categories = @local_categories_strs.join(',')
#    breakpoint
  end

  def plans_ids=(new_plan_ids)
    @local_new_plan_ids = new_plan_ids
    self.plans = Plan.find(@local_new_plan_ids)
  end
end
