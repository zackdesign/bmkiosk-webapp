class KplansController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'kiosk_inside'

  def list
    @phone = Phone.find(params[:id])

    @plan_groups_consumer = PlanGroup.find_all_by_categories("consumer")
    if @plan_groups_consumer.nil?
      @plan_groups_consumer = Array.new
    end
#    @plans_consumer = Array.new
#    @plan_groups_consumer.each do |plan_group|
#      @plans_in_group = plan_group.plans
#    end
#    @plan_groups_consumer
    @plan_groups_business = PlanGroup.find_all_by_categories("business")
    if @plan_groups_business.nil?
      @plan_groups_business = Array.new
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end
end
