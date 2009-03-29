class KplansController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'kiosk_inside'

  def index
    @phone = nil

    @plan_groups_consumer = PlanGroup.find_all_by_categories("consumer")
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end
    @plan_groups_business = PlanGroup.find_all_by_categories("business")
    if @plan_groups_business.nil?
      @plan_groups_business = Array.new
    end
    
    @page_title = 'Plan Choice'
    
    respond_to do |format|
      format.html { render :action => "list" }
      format.xml  { render :xml => @phone }
    end
  end

  def list
    @phone = Phone.find(params[:id])

    # First find all the plans that are available with the chosen phone
    @plans = Plan.find_by_sql("SELECT p.* FROM plans p, phones_plans pp WHERE p.id = pp.plan_id AND pp.phone_id = " + params[:id])

    # Now extract a collection containing each plan group id associated with each plan found
    @plan_group_ids = @plans.collect { |plan| plan.plan_group.id }
        
    # add in the MRO plans (BAD BAD BAD this should not be hard-coded!!)
#    @plan_mro_ids = [11,16,17,12]

    # Now find the consumer plan groups
    @plan_groups_consumer = PlanGroup.find_all_by_categories_and_id("consumer", @plan_group_ids)
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end
    
#    @consumer_mro = PlanGroup.find_all_by_categories_and_id("consumer", @plan_mro_ids)
    @consumer_mro = PlanGroup.find_all_by_categories_and_applies_all_phones("consumer", 1)
    if @consumer_mro.nil?
          @consumer_mro = Array.new
    end

    # And now find the business plan groups
    @plan_groups_business = PlanGroup.find_all_by_categories_and_id("business", @plan_group_ids)
    if @plan_groups_business.nil?
      @plan_groups_business = Array.new
    end
    
#    @business_mro = PlanGroup.find_all_by_categories_and_id("business", @plan_mro_ids)
    @business_mro = PlanGroup.find_all_by_categories_and_applies_all_phones("business", 1)
    
    @page_title = 'Plans'

    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end

  def mro
    unless params[:phone_id].nil?
      @phone = Phone.find(params[:phone_id])
      @phone_cost = @phone.outright
    else
      @phone = nil
      @phone_cost = 0
    end
    @plan = Plan.find(params[:plan_id])

    # Find the monthly cost of the plan to determine the correct tier
    name = @plan.name.split(' ')
    @plan_monthly = name[0].delete("$").to_i

    # Now get the complete set of MRO payment amounts (totals over the period)
    if (@plan_monthly <= 60)
      # First tier
      @mro_repayment_totals = mro_amounts[0 .. mro_tier_ends[0]]
    elsif (@plan_monthly <= 150)
      # Second tier
      @mro_repayment_totals = mro_amounts[(mro_tier_ends[0] + 1) .. mro_tier_ends[1]]
    else
      # Third tier
      @mro_repayment_totals = mro_amounts[(mro_tier_ends[1] + 1) .. mro_tier_ends[2]]
    end

    @page_title = 'Monthly Repayment Options'

    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end

  def summary
    unless params[:phone_id].nil?
      @phone = Phone.find(params[:phone_id])
      @phone_outright = @phone.outright
    else
      @phone = nil
    end
    @plan = Plan.find(params[:plan_id])
    
    @contract_length = params[:contract_length].to_i
    @mro_amount = params[:mro_payment_total].to_f
    @upfront_cost = (@phone_outright >= @mro_amount) ? @phone_outright - @mro_amount : 0
    @monthly_mro_amount = (@contract_length > 0) ? @mro_amount / @contract_length : 0
    
    @page_title = 'Summary'
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end
  
  
  
  def phone
    @phones = Plan.find_by_sql("SELECT p.* FROM phones p, phones_plans pp WHERE p.id = pp.phone_id AND pp.plan_id = " + params[:id])
    @plan = params[:id]
    
    @page_title = 'Choose Phone'
    respond_to do |format|
          format.html
          format.xml  { render :xml => @phone }
    end
  end
  
  def mro_amounts
    [
      # Low Tier
      49.00,
      99.00,
      149.00,
      199.00,
      229.00,
      259.00,
      289.00,
      319.00,
      349.00,
      379.00,
      409.00,
      439.00,
      469.00,
      499.00,
      529.00,
      559.00,
      589.00,
      619.00,
      649.00,
      679.00,

      # High Tier
      729.00,
      779.00,
      829.00,
      879.00,
      929.00,
      979.00,
      999.00,

      # Premium Tier
      1099.00,
      1199.00,
      1299.00,
      1399.00,
      1499.00
    ]
  end

  def mro_tier_ends
    [
      19,
      26,
      31
    ]
  end
end
