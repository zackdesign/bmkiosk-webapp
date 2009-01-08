class PhoneCompareLinkRenderer < WillPaginate::LinkRenderer
  def page_link(page, text, attributes = {})
    attributes[:onclick] = "return goto_page(" + page.to_s + ", '" + url_for(page) + "');"
#    @template.link_to text, url_for(page), attributes
    @template.link_to text, '#', attributes
  end
end

class PhonesController < ApplicationController
  require 'RMagick'
  include Magick

  
  layout 'bmweb'

  # GET /phones
  # GET /phones.xml
  def index
#    @phones = Phone.find(:all)

    # Get a list of unique phone brand names
    @phone_brands = get_phone_brands()
    @selected_brand = ""

    # Get a list of phone network types
    @networks = get_phone_networks()

    # Get a list of features
    @features = Feature.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phones }
    end

#    redirect_to :action => 'offers'
#    redirect_to :url => 'phone/list/offers'
  end

  # GET /phones/list
  # GET /phones/list.xml
  def list
    # Get a list of unique phone brand names
#    @phone_brands = get_phone_brands()
#    @selected_brand = params[:brand]

    # Build a list of conditions that the phones have to meet
    conditions = "";
    unless ((params[:brand] == nil) or (params[:brand].empty?))
      conditions += "brand = '" + params[:brand] + "'"
    end

    unless ((params[:purchase_type] == nil) or (params[:purchase_type].empty?))
      unless (conditions.empty?)
        conditions += " AND "
      end
      if (params[:purchase_type] == "monthly")
        conditions += "prepaid IS NULL"
      elsif (params[:purchase_type] == "prepaid")
        conditions += "NOT prepaid IS NULL"
      end
    end

    unless ((params[:network] == nil) or (params[:network].empty?))
      unless (conditions.empty?)
        conditions += " AND "
      end
      conditions += "network = '" + params[:network] + "'"
    end

    # Get a list of phones that match the specified search criteria
    unless (conditions.empty?)
      @phones = Phone.find(:all, :conditions => conditions)
    else
      @phones = Phone.find(:all)
    end

    # Filter the list of phones further based upon conditions that cross table boundaries e.g. features
    unless ((params[:feature] == nil) or (params[:feature].empty?))
#      unless (conditions.empty?)
#        conditions += " ";
#      end
#      conditions += "feature IN (" + params[:feature].join(", ") + ")"
      @phones.delete_if { |phone| !phone_has_features(phone, params[:feature]) }
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @phones }
    end
  end

  # GET /phones/1
  # GET /phones/1.xml
  def show
    @phone = Phone.find(params[:id])
    
    @page_title = ' - '+@phone.name

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end

  def offers
    @phones = Phone.find(:all)
  end

  def prepaid
    @limit = 3
#    @offset = (params[:offset].nil?) ? 0 : params[:offset].to_i
    @compare_ids = (params[:compare_ids].nil?) ? Array.new : params[:compare_ids].split(',')
#    @count = Phone.find(:all, :conditions => 'NOT prepaid IS NULL').length
#    @phones = Phone.find(:all, :conditions => 'NOT prepaid IS NULL', :offset => @offset, :limit => @limit)

    page = (params[:page].nil?) ? 1 : params[:page]
    @phones = Phone.paginate :all, :conditions => 'NOT prepaid IS NULL', :page => page, :per_page => @limit
  end

  def nextg
    @limit = 3
#    @offset = (params[:offset].nil?) ? 0 : params[:offset].to_i
    @compare_ids = (params[:compare_ids].nil?) ? Array.new : params[:compare_ids].split(',')
#    @count = Phone.find(:all, :conditions => "network = 'NextG'").length
#    @phones = Phone.find(:all, :conditions => "network = 'NextG'", :offset => @offset, :limit => @limit)

    page = (params[:page].nil?) ? 1 : params[:page]
    @phones = Phone.paginate_all_by_network 'NextG', :page => page, :per_page => @limit
  end

  def pda
    @limit = 3
#    @offset = (params[:offset].nil?) ? 0 : params[:offset].to_i
    @compare_ids = (params[:compare_ids].nil?) ? Array.new : params[:compare_ids].split(',')
#    @count = Phone.find(:all, :order => 'brand ASC').length
#    @phones = Phone.find(:all, :order => 'brand ASC', :offset => @offset, :limit => @limit)

    page = (params[:page].nil?) ? 1 : params[:page]
    @phones = Phone.paginate :all, :order => 'brand ASC', :page => page, :per_page => @limit
  end

  def compare
    @compare_ids = params[:compare_ids].split(',')
    @phones = Phone.find(@compare_ids)
	@features = Array.new
    for @ph in @phones
      for @f in @ph.features
   	    unless @features.include? @f
   	      @features.concat [ @f ]
   	    end
   	  end
    end

    case params[:id]
      when 'prepaid'
        render :template => 'phones/compare.html.erb'

      when 'nextg'
        render :template => 'phones/compare.html.erb'

      when 'pda'
        render :template => 'phones/compare.html.erb'

      else
        # TODO: What to do ???
    end
  end

  # GET /phones/new
  # GET /phones/new.xml
#  def new
#    @phone = Phone.new
#
#    respond_to do |format|
#      format.html # new.html.erb
#      format.xml  { render :xml => @phone }
#    end
#  end

  # GET /phones/1/edit
#  def edit
#    @phone = Phone.find(params[:id])
#  end

  # POST /phones
  # POST /phones.xml
#  def create
#    @phone = Phone.new(params[:phone])
#
#    respond_to do |format|
#      if @phone.save
#        flash[:notice] = 'Phone was successfully created.'
#        format.html { redirect_to(@phone) }
#        format.xml  { render :xml => @phone, :status => :created, :location => @phone }
#      else
#        format.html { render :action => "new" }
#        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # PUT /phones/1
  # PUT /phones/1.xml
#  def update
#    @phone = Phone.find(params[:id])
#
#    respond_to do |format|
#      if @phone.update_attributes(params[:phone])
#        flash[:notice] = 'Phone was successfully updated.'
#        format.html { redirect_to(@phone) }
#        format.xml  { head :ok }
#      else
#        format.html { render :action => "edit" }
#        format.xml  { render :xml => @phone.errors, :status => :unprocessable_entity }
#      end
#    end
#  end

  # DELETE /phones/1
  # DELETE /phones/1.xml
#  def destroy
#    @phone = Phone.find(params[:id])
#    @phone.destroy
#
#    respond_to do |format|
#      format.html { redirect_to(phones_url) }
#      format.xml  { head :ok }
#    end
#  end

  def get_phone_brands()
#    @brands_hash = Hash.new
#    @phones = Phone.find(:all)
#    unless (@phones == nil)
#      @phones.each { |phone|
#        unless (@brands_hash.include? phone.brand)
#          @brands_hash[phone.brand] = true
#        end
#      }
#    end
#    @brands = @brands_hash.to_a

    @brands_records = Phone.find(:all, :select => "DISTINCT brand", :order => "brand ASC")
    @brands = Array.new(1, ["All Phones Brands", ""])

    unless (@brands_records == nil)
      @brands_records.each { |brand_record| @brands << [brand_record.brand, brand_record.brand] }
    end

    return @brands
  end

  def get_phone_networks()
    @networks_records = Phone.find(:all, :select => "DISTINCT network", :order => "network ASC")
    @networks = Array.new(1, ["Don't Mind", ""])

    unless (@networks_records == nil)
      @networks_records.each { |network_record| @networks << [network_record.network, network_record.network] }
    end

    return @networks
  end

  def phone_has_features(phone, feature_ids)
    has_features = false

    unless ((phone.features == nil) or (phone.features.empty?))
      for feature_id in feature_ids
        @feature = Feature.find(feature_id)
        if (phone.features.include?(@feature))
          has_features = true
        else
          has_features = false
          break
        end
      end
    end

    return has_features
  end

  def thumbnail
    # Create a thumbnail image of the uploaded picture for the phone list
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    thumb = image.thumbnail(128, 128)
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end

  def feature_thumb
    # Create a thumbnail image of the uploaded picture for the feature list
    @feature = Feature.find(params[:id])
    image = Magick::Image.from_blob(@feature.picture_data).first
    thumb = image.thumbnail(32, 32)
    send_data thumb.to_blob, :filename => @feature.picture_name,
              :type => @feature.picture_type, :disposition => "inline"
  end

  def offer_picture
    # Create a resized image of the uploaded picture for when the phone is shown
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 120
      thumb = image
    else
      thumb = image.resize_to_fit(150, 150)
    end
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end

  def picture
    # Create a resized image of the uploaded picture for when the phone is shown
    @phone = Phone.find(params[:id])
    image = Magick::Image.from_blob(@phone.picture_data).first
    max_dimension = (image.columns < image.rows) ? image.rows : image.columns
    if max_dimension < 300
      thumb = image
    else
      thumb = image.resize_to_fit(300, 300)
    end
    send_data thumb.to_blob, :filename => @phone.picture_name,
              :type => @phone.picture_type, :disposition => "inline"
  end

  def actual
    # Send the uploaded image actual size to the browser
    @phone = Phone.find(params[:id])
    unless (@phone == nil)
      unless (@phone.picture_data == nil)
        send_data @phone.picture_data, :filename => @phone.picture_name,
                  :type => @phone.picture_type, :disposition => "inline"
      end
      unless (@phone.picture2_data == nil)
        send_data @phone.picture2_data, :filename => @phone.picture2_name,
                  :type => @phone.picture2_type, :disposition => "inline"
      end
      unless (@phone.picture3_data == nil)
        send_data @phone.picture3_data, :filename => @phone.picture3_name,
                  :type => @phone.picture3_type, :disposition => "inline"
      end
    end
  end
end
