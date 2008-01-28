class AccessoriesController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'personal'

  # GET /accessories
  # GET /accessories.xml
  def index
    @accessories = Accessory.find(:all)

    # Get a list of phone brands
    @phone_brands = get_phone_brands()
    @selected_brand = ""

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accessories }
    end
  end

  # GET /accessories/1
  # GET /accessories/1.xml
  def show
    @accessory = Accessory.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @accessory }
    end
  end

  # GET /accessories/new
  # GET /accessories/new.xml
  def new
    @accessory = Accessory.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @accessory }
    end
  end

  # GET /accessories/1/edit
  def edit
    @accessory = Accessory.find(params[:id])
  end

  # POST /accessories
  # POST /accessories.xml
  def create
    @accessory = Accessory.new(params[:accessory])

    respond_to do |format|
      if @accessory.save
        flash[:notice] = 'Accessory was successfully created.'
        format.html { redirect_to(@accessory) }
        format.xml  { render :xml => @accessory, :status => :created, :location => @accessory }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @accessory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /accessories/1
  # PUT /accessories/1.xml
  def update
    @accessory = Accessory.find(params[:id])

    respond_to do |format|
      if @accessory.update_attributes(params[:accessory])
        flash[:notice] = 'Accessory was successfully updated.'
        format.html { redirect_to(@accessory) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @accessory.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /accessories/1
  # DELETE /accessories/1.xml
  def destroy
    @accessory = Accessory.find(params[:id])
    @accessory.destroy

    respond_to do |format|
      format.html { redirect_to(accessories_url) }
      format.xml  { head :ok }
    end
  end

  def offer_picture
    # Create a resized image of the uploaded picture for when the phone is shown
    @accessory = Accessory.find(params[:id])
    image = Magick::Image.from_blob(@accessory.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 120
      thumb = image
    else
      thumb = image.resize_to_fit(120, 120)
    end
    send_data thumb.to_blob, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end

  def get_phone_brands()
    @brands_records = Phone.find(:all, :select => "DISTINCT brand", :order => "brand ASC")
    @brands = Array.new(1, ["All Phones Brands", ""])

    unless (@brands_records == nil)
      @brands_records.each { |brand_record| @brands << [brand_record.brand, brand_record.brand] }
    end

    return @brands
  end
end
