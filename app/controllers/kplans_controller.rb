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

    # Now find the consumer plan groups
    @plan_groups_consumer = PlanGroup.find_all_by_categories_and_id("consumer", @plan_group_ids)
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end

    # And now find the business plan groups
    @plan_groups_business = PlanGroup.find_all_by_categories_and_id("business", @plan_group_ids)
    if @plan_groups_business.nil?
      @plan_groups_business = Array.new
    end

    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end

  def summary
    unless params[:phone_id].nil?
      @phone = Phone.find(params[:phone_id])
    else
      @phone = nil
    end
    @plan = Plan.find(params[:plan_id])

    respond_to do |format|
      format.html
      format.xml  { render :xml => @phone }
    end
  end
  
  def phone
    @phones = Plan.find_by_sql("SELECT p.* FROM phones p, phones_plans pp WHERE p.id = pp.phone_id AND pp.plan_id = " + params[:id])
    @plan = params[:id]
    respond_to do |format|
          format.html
          format.xml  { render :xml => @phone }
    end
  end
end
