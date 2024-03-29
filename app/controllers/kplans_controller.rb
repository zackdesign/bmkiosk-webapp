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
    begin
      @plan_group_ids = @plans.collect { |plan| plan.plan_group.id }

    # Now find the consumer plan groups
    @plan_groups_consumer = PlanGroup.find_all_by_categories_and_id("consumer", @plan_group_ids)
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end
    
    @consumer_mro = PlanGroup.find_all_by_categories_and_applies_all_phones("consumer", 1)
    if @consumer_mro.nil?
          @consumer_mro = Array.new
    end

    # And now find the business plan groups
    @plan_groups_business = PlanGroup.find_all_by_categories_and_id("business", @plan_group_ids)
    if @plan_groups_business.nil?
      @plan_groups_business = Array.new
    end
    
    @business_mro = PlanGroup.find_all_by_categories_and_applies_all_phones("business", 1)

    rescue
        # no need to do anything here - this is if the plan group fails
    end

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
    
    #Only show periods for the plan that are already set in the DB
    @periods = Array.new
    unless @plan.period.blank?
    
      if @plan.period.include?("12")
        @periods << ['12 months',12]
      end
      if @plan.period.include?("18")
        @periods << ['18 months',18]
      end
      if @plan.period.include?("24")
        @periods << ['24 months',24]
      end
    
    end
    
    # Check to make sure that this isn't a subsidized plan
    @applies = params[:applies]
    if @applies.blank?
      @applies = false
    end

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

    @page_title = 'Contract Options'

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
      @phone_outright = 0
    end
    @plan = Plan.find(params[:plan_id])
    if (params[:contract_length].blank?)
        contract = ''
    else
        contract = params[:contract_length]
    end
    
    @contract_length = params[:contract_length].to_i
    @mro_amount = params[:mro_payment_total].to_f
    @upfront_cost = (@phone_outright >= @mro_amount) ? @phone_outright - @mro_amount : 0
    @monthly_mro_amount = (@contract_length > 0) ? @mro_amount / @contract_length : 0
    if (@plan.description.downcase.include?('$0') )
        @upfront_cost = 0
    end
    @period = contract + ' months'
    
    @page_title = 'Summary'
    
    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end
  
  
  
  def phone
    @phones = Phone.find_by_sql("SELECT p.* FROM phones p, phones_plans pp WHERE discontinued = 0 AND outofstock = 0 AND coming_soon = 0 AND p.id = pp.phone_id AND pp.plan_id = " + params[:id] + " ORDER BY name ASC")

    @plan = Plan.find(params[:id])
    unless @plan.period.blank? || @plan.period == 'Nill' || @plan.period == 'NULL' 
      mropage = true
    else
      mropage = false
    end
    
    @action = mropage ? "mro" : "summary"
    
    if (@plan.plan_group.applies_all_phones == true) && (@phones.empty?)
      @phones = Phone.find(:all, :conditions => 'discontinued = 0 AND outofstock = 0 AND coming_soon = 0', :order => 'name ASC' )
    end
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
  
   def thumbnail
    # Create a resized image of the uploaded picture for when the phone is shown
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 50
      thumb = image
    else
      thumb = image.resize_to_fit(50, 50)
    end
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end
end
