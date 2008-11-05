class KioskController < ApplicationController

  require 'RMagick'
  include Magick

  layout 'kiosk'
  
  def show
    phones = Phone.find_by_sql('SELECT p.id, p.name, p.picture_name, p.picture_data
                                FROM kiosks AS k, phones AS p
                                WHERE k.kiosk = '+params[:id]+'
                                AND p.id = k.phone_id')
    
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r\n"
    xml += "<slide_show>\r\n"
    xml += "<options>\r\n
            <background>#FFFFFF</background>\r\n
            <interaction>\r\n
                <speed>10</speed>\r\n
                <default_view_point>50%</default_view_point>\r\n
            </interaction>\r\n
	  </options>\r\n"
    
    for p in phones
    
      image = Magick::Image.from_blob(p.picture_data).first
      
      max_dimension = (image.columns < image.rows) ? image.rows : image.columns
          if max_dimension < 220
            thumb = image
          else
            thumb = image.resize_to_fit(220, 220)
      end
    
      File.open('public/kiosk_images/'+p.picture_name,'w'){|f| f.write(thumb.to_blob)}
      
      xml += "\t<photo href=\"#\" alt='"+p.name+"' target=\"_self\">/kiosk_images/"+p.picture_name+"</photo>\r\n"
    
    end
    
    xml += "</slide_show>\r\n"
    
    local_filename = 'public/xml/kiosk'+params[:id]+'.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end

end