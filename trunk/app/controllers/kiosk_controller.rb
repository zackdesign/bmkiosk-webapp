class KioskController < ApplicationController

  require 'RMagick'
  include Magick

  layout 'kiosk'
  
  def touch
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
      
      xml += "\t<photo href=\"/phones/"+p.id.to_s+"\" alt='"+p.name+"' target=\"_self\">/kiosk_images/"+p.picture_name+"</photo>\r\n"
    
    end
    
    xml += "</slide_show>\r\n"
    
    local_filename = 'public/xml/kiosk'+params[:id]+'.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end
  
  def plasma
    @plasma = '4'
    phones = Phone.find_by_sql('SELECT p.id, p.name, p.picture_type, p.picture_name, p.picture_data
                                FROM kiosks AS k, phones AS p
                                WHERE k.kiosk = "'+@plasma+'"
                                AND p.id = k.phone_id')
    
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r\n"
    xml += '	<slideshow  displayTime="20" transitionSpeed=".7" transitionType="Fade" motionType="None" motionEasing="easeInOut" randomize="true"
                            slideshowWidth="auto" slideshowHeight="auto" slideshowX="center" slideshowY="center" bgColor="FFFFFF" bgOpacity="100"
                            useHtml="true" showHideCaption="false" captionBg="000000" captionBgOpacity="80" captionTextSize="20" captionTextColor="FFFFFF"
                            captionBold="true" 	captionPadding="7" showNav="false" autoHideNav="true" navHiddenOpacity="15" navX="center"
                             navY="center" btnColor="FFCC00" btnHoverColor="ffffff" btnShadowOpacity="70"  btnGradientOpacity="20" btnScale="120"
                                	btnSpace="10"  navBgColor="333333" navBgAlpha="95" navCornerRadius="20" navBorderWidth="2" navBorderColor="FFFFFF"
                                
				navBorderAlpha="100"
				navPadding="10"
				tooltipSize="8"
				tooltipColor="000000"
				tooltipBold="true"
				tooltipFill="FFFFFF"
				tooltipStrokeColor="000000"
				tooltipFillAlpha="80"
				tooltipStroke="0"
				tooltipStrokeAlpha="0"
				tooltipCornerRadius="8"
				loaderWidth="200"
				loaderHeight="1"
				loaderColor="FF0000"
				loaderOpacity="100" 
				
				attachCaptionToImage="true"
				imageScaling="downFill"
				slideshowMargin="0"
				showMusicButton="false"
				music=""
				musicVolume="100"
				musicMuted="true"
				musicLoop="true"
				watermark=""
				watermarkX="625"
				watermarkY="30"
				watermarkOpacity="100"
				watermarkLink=""
				watermarkLinkTarget="_blank"
				captionsY="absbottom"
				>'
    
    for p in phones
      
      if p.picture_type == 'image/jpeg' || p.picture_type == 'image/pjpeg'
         File.open('public/kiosk_images/slideshow/'+p.picture_name,'w'){|f| f.write(p.picture_data)}
         picture_name = p.picture_name
      else
         image = Magick::Image.from_blob(p.picture_data).first
         
         File.open('public/kiosk_images/slideshow/'+p.picture_name+'.jpg','w'){|f| f.write(image.to_blob{self.format = "jpg"})}
         picture_name = p.picture_name+'.jpg'
      end
      
      extra = ''
      
      unless p.features.empty?
      
        for f in p.features
          extra += ''+f.name+' ' 
        end
      
      end
      
      xml += "<image img='/kiosk_images/slideshow/"+picture_name+"' caption='"+p.name+'
      
'+extra+"' />\r\n"
    
    end
    
    xml += "</slideshow>\r\n"
    
    local_filename = 'public/xml/plasma.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end

end