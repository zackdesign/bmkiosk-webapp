class KphonesController < ApplicationController
  require 'RMagick'
  include Magick
  
  layout 'kiosk_inside'
 
  def show
    @phone = Phone.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @phone }
    end
  end
  
  

end