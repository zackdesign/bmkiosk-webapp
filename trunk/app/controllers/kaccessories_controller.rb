class KaccessoriesController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'kiosk_inside'

  # GET /accessories
  # GET /accessories.xml
  def index

    unless ((params[:brand].nil?) || (params[:brand].empty?))
      @selected_brand = params[:brand]
    else
      @selected_brand = ""
    end

    @page = (params[:page].nil?) ? 1 : params[:page]
    unless @selected_brand.empty?
      @accessories = Accessory.paginate_by_brand @selected_brand, :page => @page, :per_page => 9
    else
      @accessories = Accessory.find(:all, :order => 'name ASC')
    end
    
    @page_title ='Mobile Accessories'
    
    # Get a list of phone brands
    @phone_brands = get_phone_brands()

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accessories }
    end
  end
  
  def show 
    @accessory = Accessory.find(params[:id])
    @page_title =@accessory.name
  end
  
    def get_phone_brands()
      @brands_records = Phone.find(:all, :select => "DISTINCT brand", :order => "brand ASC")
      @brands = Array.new(1, ["All Phones Brands", ""])
  
      unless (@brands_records == nil)
        @brands_records.each { |brand_record| @brands << [brand_record.brand, brand_record.brand] }
      end
  
      return @brands
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
  
end
