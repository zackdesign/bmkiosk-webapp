# == Schema Information
# Schema version: 26
#
# Table name: plans
#
#  id           :integer(24)   not null, primary key
#  name         :string(255)   
#  categories   :(0)           default("consumer"), not null
#  comments     :text          
#  handset_cost :decimal(9, 2) 
#  code         :text          
#  offer_price  :decimal(9, 2) 
#  offer        :string(255)   
#  period       :integer(11)   
#  created_at   :datetime      
#  updated_at   :datetime      
#  discontinued :boolean(1)    
#  handset      :integer(24)   
#  plan_group   :integer(24)   
#  repayments   :decimal(9, 2) 
#  charge_type  :integer(11)   
#

class Plan < ActiveRecord::Base

  validates_presence_of :name
  has_and_belongs_to_many :phones
  belongs_to :plan_group
#  has_many :charges
  has_and_belongs_to_many :charges
  has_and_belongs_to_many :options, :join_table => "plans_options"
  
  def plan_category_set=(new_categories)
    @local_new_categories = new_categories
    categories = @local_new_categories.join(",")
    self.categories = categories;
  end

  def plan_phones_handset_set=(new_handsets)
    @local_new_handsets = new_handsets
    @ids = nil
    @costs = nil

    @local_new_handsets.delete_if { |hand| hand == "-1|-1" }
    @phone_ids = @local_new_handsets.collect { |hand| hand.split('|').first.to_i }
#    @costs = @local_new_handsets.collect { |hand| hand.split('|').last.to_f }
    @fields = @local_new_handsets.collect { |hand| hand.split('|').last }
    @costs = @fields.collect { |f| f.split('~').first.to_f }

    # Remove entries in the Phones Plans join table
    self.phones.each { |phone|
      unless phone == nil
        @phone_plan = PhonesPlans.find_by_plan_id_and_phone_id(self.id, phone.phone_id)
        unless @phone_plan == nil
          @phone_plan.destroy
        end
      end
    }

    # Need to save the Plan record here in case it is a new one, because the self.id attribute won't
    # be valid (i.e. it will be nil) until the record is created in the database. If it isn't valid,
    # then NULL values will be created in the database and the Phone will appear not to be saved.
    self.save

    # Find or create entries in the Phones Plans join table      
    @new_phones_plans = @phone_ids.collect { |pid|
      PhonesPlans.find_or_create_by_plan_id_and_phone_id(self.id, pid)
    }

    # Now modify the Phones Plans table entries found / created above with the additional information
    # given by the user i.e. handset cost, MRO, etc.
    for pp in 0..(@new_phones_plans.length - 1)
      @new_phones_plans[pp].handset_cost = @costs[pp]
      @new_phones_plans[pp].save
    end
  end

  def plan_charge_type=(new_charge_type)
    @local_new_charge_type = new_charge_type

    if self.charge_type == @local_new_charge_type.to_i
      return
    end

    if @local_new_charge_type == ''
      @local_new_charge_type = nil
    end

    @new_charges = []
    unless @local_new_charge_type == nil
      @new_charge_fields = ChargeTypeField.find(:all, :conditions => 'charge_type_id = ' + @local_new_charge_type.to_s)
      @new_charges = @new_charge_fields.collect { |cf|
        @new_charge = Charge.new
        @new_charge.plan_id = self.id
        @new_charge.charge_type_field = cf.id
        @new_charge
      }
    end

    if self.charges.length > 0
      self.charges.each { |c| c.destroy }
    end
    self.charges = @new_charges
    self.charge_type = @local_new_charge_type
  end

  def charges_values=(new_charges_values)
    @local_new_charges_values = new_charges_values

    if self.charges.length > 0 && self.charges.length == @local_new_charges_values.length
      for @i in 0..(self.charges.length - 1)
        @new_charge = Charge.new(self.charges[@i].attributes)
        @new_charge.value = @local_new_charges_values[@i]
        self.charges[@i].destroy
        self.charges[@i] = @new_charge
      end
    end
  end
  
    def options_to_plans=(option_ids)
#    self.features = Feature.find(feature_ids)
    @local_option_ids = option_ids
    if @local_option_ids.include?("-1")
      @options = []
    else
      @options = Option.find(@local_option_ids)
    end
    self.options = @options
  end
  
  def charges_to_plan=(new_charge_ids)
    @local_new_charge_ids = new_charge_ids
    
    if @local_new_charge_ids.include?("-1")
      @charges = []
    else
      @charges = Charge.find(@local_new_charge_ids)
    end
    
    self.charges = @charges
  end
end
