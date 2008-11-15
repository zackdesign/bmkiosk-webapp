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

    @plans = Plan.find_all_by_handset(params[:id])
    @plan_group_ids = @plans.collect { |plan| plan.plan_group.id }

    @plan_groups_consumer = PlanGroup.find_all_by_categories_and_id("consumer", @plan_group_ids)
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end

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
end
