class KphonesController < ApplicationController
  require 'RMagick'
  include Magick
  
  layout 'kiosk_inside'

  def show
    @phone = Phone.find(params[:id])
    
    unless FileTest.exist?("public/kiosk_images/#{@phone.picture_name}")
      image = Magick::Image.from_blob(@phone.picture_data).first
      
      max_dimension = (image.columns < image.rows) ? image.rows : image.columns
                if max_dimension < 300
                  thumb = image
                else
                  thumb = image.resize_to_fit(300, 300)
      end
      
      File.open('public/db_images/phones/'+@phone.picture_name,'w'){|f| f.write(thumb.to_blob)}
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end
  
  

end