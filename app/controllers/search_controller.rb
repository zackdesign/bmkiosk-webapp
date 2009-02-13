class SearchController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'bmweb'

  # GET /search
  # GET /search.xml
  def index
    @is_new_search = (params[:new_search].nil? or params[:new_search].to_i == 0) ? true : false
    @new_search_input = (params[:inpSearch].nil? or params[:inpSearch].empty?) ? '' : params[:inpSearch]
    @prev_search_input = (params[:inpPreviousSearch].nil? or params[:inpPreviousSearch].empty? or @is_new_search) ? '' : params[:inpPreviousSearch]
    @search_input = @new_search_input + ((@prev_search_input.empty?) ? '' : (' ' + @prev_search_input))

    unless @search_input.nil? or @search_input.empty?
      @keywords = @search_input.split(" ")
      @conditions = ''

      # Build the database query
      unless @keywords.empty?
        @conditions = @keywords.collect { |keyword|
          '((name LIKE "%' + keyword + '%") OR (description LIKE "%' + keyword + '%"))'
        }.join(" AND ")
      end

#      @conditions = ''
#      unless @keywords.empty?
#        @conditions = '(' + @keywords.collect { |keyword|
#          '(name LIKE "%' + keyword + '%")'
#        }.join(" AND ") + ')'
#
#        @conditions = @conditions + ' OR (' + @keywords.collect { |keyword|
#          '(description LIKE "%' + keyword + '%")'
#        }.join(" AND ") + ')'
#      end

      @plans = Plan.find(:all, :conditions => @conditions)
      @phones = Phone.find(:all, :conditions => @conditions)
      @accessories = Accessory.find(:all, :conditions => @conditions)
    else
      @plans = Array.new
      @phones = Array.new
      @accessories = Array.new
    end

    respond_to do |format|
      format.html # index.html.erb
#      format.xml  { render :xml => @search }
    end
  end

  # GET /search/1
  # GET /search/1.xml
  def show
    respond_to do |format|
      format.html # show.html.erb
#      format.xml  { render :xml => @search }
    end
  end

  # GET /search/new
  # GET /search/new.xml
  def new
    respond_to do |format|
      format.html # new.html.erb
#      format.xml  { render :xml => @search }
    end
  end

  # GET /search/1/edit
  def edit
  end

  # POST /search
  # POST /search.xml
  def create
  end

  # PUT /search/1
  # PUT /search/1.xml
  def update
    respond_to do |format|
      if @search.update_attributes(params[:search])
        flash[:notice] = 'Search was successfully updated.'
        format.html { redirect_to(@search) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @search.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /search/1
  # DELETE /search/1.xml
  def destroy
    respond_to do |format|
      format.html { redirect_to(search_url) }
      format.xml  { head :ok }
    end
  end
end
