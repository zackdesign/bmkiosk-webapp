class AccessoriesController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'bmweb'

  # GET /accessories
  # GET /accessories.xml
  def index
#    @accessories = Accessory.find(:all)
#    @limit = 3
#    @offset = (params[:offset].nil?) ? 0 : params[:offset].to_i
#    @count = Accessory.find(:all).length
#    @accessories = Accessory.find(:all, :offset => @offset, :limit => @limit)

    unless ((params[:brand].nil?) || (params[:brand].empty?) || (params[:brand] == 'All Brands'))
      @selected_brand = params[:brand]
      @brand = ' for '+@selected_brand
      @page_title = ' - '+@selected_brand
    else
      @selected_brand = ""
    end

    @page = (params[:page].nil?) ? 1 : params[:page]
    unless @selected_brand.empty?
      @accessories = Accessory.paginate :page => @page, :per_page => 9, :conditions => ['name like ?', '%'+@selected_brand+'%'], :order => 'name'
    else
      @accessories = Accessory.paginate :page => @page, :per_page => 10, :order => 'name'
    end

    # Get a list of phone brands
    @phone_brands = get_phone_brands()
    
    @sorting = true

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @accessories }
    end
  end
  
  
  def cartadd
    begin                     
      accessory = Accessory.find(params[:id])  
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      flash[:notice] = "Invalid product"
      redirect_to(:action => "index") and return
    else
      find_id = ActiveRecord::Base.connection.select_value("SELECT id FROM products WHERE title LIKE '"+accessory.name+"'")
      if(find_id)
        ActiveRecord::Base.connection.execute("UPDATE products SET price = '"+accessory.price.to_s()+"' WHERE id = '"+find_id.to_s()+"'")
        last_id = find_id 
      else 
        ActiveRecord::Base.connection.execute("INSERT INTO products (title, price) VALUES ('"+accessory.name+"', '"+accessory.price.to_s()+"')")
        last_id = ActiveRecord::Base.connection.select_value("SELECT id FROM products WHERE id = LAST_INSERT_ID()") 
      end
      add_to_cart(last_id)
    end
      flash.now[:notice] = "Added to cart"

    unless ((params[:brand].nil?) || (params[:brand].empty?))
      @selected_brand = params[:brand]
    else
      @selected_brand = ""
    end

    @page = (params[:page].nil?) ? 1 : params[:page]
    redirect_to(:action => "index", :page => @page, :brand => @selected_brand )
  end

  # GET /accessories/1
  # GET /accessories/1.xml
  def show
    @accessory = Accessory.find(params[:id])
    @page_title = ' - '+@accessory.name
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
  
  def thumbnail
    # Create a resized image of the uploaded picture for when the phone is shown
    @accessory = Accessory.find(params[:id])
    image = Magick::Image.from_blob(@accessory.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 40
      thumb = image
    else
      thumb = image.resize_to_fit(40, 40)
    end
    send_data thumb.to_blob, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end

  def offer_picture
    # Create a resized image of the uploaded picture for when the phone is shown
    @accessory = Accessory.find(params[:id])
    image = Magick::Image.from_blob(@accessory.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 120
      thumb = image
    else
      thumb = image.resize_to_fit(150, 150)
    end
    send_data thumb.to_blob, :filename => @accessory.picture_name,
              :type => @accessory.picture_type, :disposition => "inline"
  end

  def get_phone_brands()
    @brands_records = Phone.find(:all, :select => "DISTINCT brand", :order => "brand ASC")
    @brands = Array.new(1, "All Brands")

    unless (@brands_records == nil)
      @brands_records.each { |brand_record| @brands << brand_record.brand }
    end

    return @brands
  end

  def actual
    # Send the uploaded image actual size to the browser
    @accessory = Accessory.find(params[:id])
    unless (@accessory.nil?)
      unless (@accessory.picture_data.nil?)
        send_data @accessory.picture_data, :filename => @accessory.picture_name,
                  :type => @accessory.picture_type, :disposition => "inline"
      end
    end
  end
end
