class PlansController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'bmweb'
  
  protect_from_forgery :only => [:create, :update, :destroy] 

  # GET /plans
  # GET /plans.xml
  def index
    # Get a list of phone network types
    @networks = get_phone_networks()

    unless params[:id].nil?
      @phone = Phone.find(params[:id])
    else
      @phone = nil
    end

    @plan_type = ''
    @show_sub_plan_type = false
    @show_repay_period = false
    @show_avg_spend = false

    unless params[:plan_type].nil?
      @plan_type = params[:plan_type]
      case @plan_type
        when 'cap'
          @show_repay_period = true
          @show_avg_spend = true
        when 'phone'
          @show_sub_plan_type = true
          @show_avg_spend = true
        when 'member'
          @show_sub_plan_type = true
          @show_repay_period = true
          @show_avg_spend = true
      end
    else
      @plan_type = ''
    end

    unless params[:is_nextg].nil?
      @is_nextg = (params[:plan_type].to_i == 1) ? true : false
    else
      @is_nextg = false
    end

    @service_type = 'new'
    
    @plan_groups_consumer = PlanGroup.find_all_by_categories("consumer")
        if @plan_groups_consumer.nil?
           @plan_groups_consumer = Array.new
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  def list
  
    @group_id = params['plan_group']['group_id']
    
    @plans = Plan.find(:all, :conditions => [ "plan_group = ?", @group_id])
    
        unless params[:service_type].nil?
          @service_type = params[:service_type]
        else
          @service_type = 'new'
    end
    
    unless params[:network].nil?
              @network = params[:network]
            else
              @network = ''
    end
    
        unless params[:existing].nil?
          @existing = params[:existing]
        else
          @existing = ''
    end
    
    # Get a list of phone network types
    @networks = get_phone_networks()
    
    respond_to do |format|
          format.html
          format.xml  { render :xml => @plans }
    end
  
  end

  def list_old
    # Get a list of phone network types
    @networks = get_phone_networks()

    unless params[:id].nil?
      @phone = Phone.find(params[:id])
    else
      @phone = nil
    end

    unless params[:sub_plan_type].nil?
      @sub_plan_type = params[:sub_plan_type]
    else
      @sub_plan_type = ''
    end

    unless params[:repayment_period].nil?
      @repayment_period = params[:repayment_period]
    else
      @repayment_period = ''
    end

    unless params[:purchase_type].nil?
      @purchase_type = params[:purchase_type]
    else
      @purchase_type = ''
    end

    unless params[:service_type].nil?
      @service_type = params[:service_type]
    else
      @service_type = 'new'
    end

    unless params[:existing].nil?
      @existing = params[:existing]
    else
      @existing = ''
    end

    unless params[:avg_spend].nil?
      @avg_spend = params[:avg_spend]
    else
      @avg_spend = ''
    end

    @plan_type = ''
    @show_sub_plan_type = false
    @show_repay_period = false
    @show_avg_spend = false

    unless params[:plan_type].nil?
      @plan_type = params[:plan_type]
      case @plan_type
        when 'cap'
          @show_repay_period = true
          @show_avg_spend = true
        when 'phone'
          @show_sub_plan_type = true
          @show_avg_spend = true
        when 'member'
          @show_sub_plan_type = true
          @show_repay_period = true
          @show_avg_spend = true
      end
    else
      @plan_type = ''
    end

    unless params[:is_nextg].nil?
      @is_nextg = (params[:plan_type].to_i == 1) ? true : false
    else
      @is_nextg = false
    end

    # FIXME: Update this to actually do a search of the plans
    @plans = Plan.find(:all, :limit => 1)

    # FIXME: Manipulation of the plans and charges data to address problem in the database structure
    unless @plans.first.charges.empty?
      @rows = @plans[0].charges[0].charge_rows
      @cols_lengths = @rows.collect { |r| r.charge_columns.length }
      @max_cols = 0
      @max_cols_row = 0
      @cols_lengths.each_index { |cli| if @cols_lengths[cli] > @max_cols
          @max_cols = @cols_lengths[cli]
          @max_cols_row = cli
        end
      }
    end

    respond_to do |format|
      format.html # list.html.erb
      format.xml  { render :xml => @plans }
    end
  end

  # GET /plans/1
  # GET /plans/1.xml
  def show
    @plan = Plan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/new
  # GET /plans/new.xml
  def new
    @plan = Plan.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @plan }
    end
  end

  # GET /plans/1/edit
  def edit
    @plan = Plan.find(params[:id])
  end

  # POST /plans
  # POST /plans.xml
  def create
    @plan = Plan.new(params[:plan])

    respond_to do |format|
      if @plan.save
        flash[:notice] = 'Plan was successfully created.'
        format.html { redirect_to(@plan) }
        format.xml  { render :xml => @plan, :status => :created, :location => @plan }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /plans/1
  # PUT /plans/1.xml
  def update
    @plan = Plan.find(params[:id])

    respond_to do |format|
      if @plan.update_attributes(params[:plan])
        flash[:notice] = 'Plan was successfully updated.'
        format.html { redirect_to(@plan) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @plan.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /plans/1
  # DELETE /plans/1.xml
  def destroy
    @plan = Plan.find(params[:id])
    @plan.destroy

    respond_to do |format|
      format.html { redirect_to(plans_url) }
      format.xml  { head :ok }
    end
  end

  def get_phone_networks()
    @networks_records = Phone.find(:all, :select => "DISTINCT network", :order => "network ASC")
#    @networks = Array.new(1, ["Don't Mind", ""])
    @networks = Array.new()

    unless (@networks_records == nil)
      @networks_records.each { |network_record| @networks << [network_record.network, network_record.network] }
    end

    return @networks
  end
end
