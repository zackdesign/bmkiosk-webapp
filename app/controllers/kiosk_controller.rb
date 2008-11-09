class KioskController < ApplicationController

  require 'RMagick'
  include Magick

  layout 'kiosk'
  
  def touch
    phones = Phone.find_by_sql('SELECT p.id, p.name, p.picture_name, p.picture_data, p.outofstock, p.discontinued
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
      
      pos = ''
      
      if p.discontinued
          picture = 'dc_'+p.picture_name
          pos =  'DISCONTINUED'
      elsif p.outofstock
          picture = 'st_'+p.picture_name
          pos = 'OUT
OF STOCK'
      else
          picture = p.picture_name
      end
      
      picture += '.jpg'
      
      unless FileTest.exist?("public/kiosk_images/#{picture}")
      
        image = Magick::Image.from_blob(p.picture_data).first
        
        big_canvas = Magick::Image.new(image.columns, image.rows+60)
        big_canvas = big_canvas.composite(image, NorthGravity, OverCompositeOp)
        
        max_dimension = (image.columns < image.rows) ? image.rows : image.columns
          if max_dimension < 220
            thumb = big_canvas
          else
            thumb = big_canvas.resize_to_fit(220, 220)
        end
        
        text = Magick::Draw.new
        text.font_family = 'Arial'
        text.pointsize = 12
        text.gravity = Magick::SouthGravity
        text.annotate(thumb, 0,0,0,0, p.name) { self.fill = 'black' }
        
        unless pos.empty?
            text.font_family = 'arial'
            text.pointsize = 20
            text.gravity = Magick::CenterGravity
            text.font_weight = 700
            text.rotation = -45
            text.annotate(thumb, 0,0,2.5,2.5, pos) { self.fill = 'gray' }
            text.annotate(thumb, 0,0,2,2, pos) { self.fill = 'black' }
            text.annotate(thumb, 0,0,0,0, pos) { self.fill = 'red' }
        end
        
        File.open('public/kiosk_images/'+picture,'w'){|f| f.write(thumb.to_blob{self.format = "jpg"})}
      
      end
      
      xml += "\t<photo href=\"/phones/"+p.id.to_s+"\" alt='"+p.name+"' target=\"_self\">/kiosk_images/"+picture+"</photo>\r\n"
    
    end
    
    xml += "</slide_show>\r\n"
    
    local_filename = 'public/xml/kiosk'+params[:id]+'.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end
  
  def plasma
    @plasma = '4'
    
    # Will also need to grab accessories
    
    phones = Phone.find_by_sql('SELECT p.id, p.name, p.picture_type, p.picture_name, p.picture_data, p.buy_price
                                FROM kiosks AS k, phones AS p
                                WHERE k.kiosk = "'+@plasma+'"
                                AND p.id = k.phone_id')
    
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r\n"
    xml += '	<slideshow  displayTime="5" transitionSpeed=".7" transitionType="Fade" motionType="None" motionEasing="easeInOut" randomize="true"
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
      
      # Redo this so that it shows the phone name beneath the phone and adds feature pics
      
      if p.picture_type == 'image/jpeg' || p.picture_type == 'image/pjpeg'
         unless FileTest.exist?("public/kiosk_images/slideshow/#{p.picture_name}")
           File.open('public/kiosk_images/slideshow/'+p.picture_name,'w'){|f| f.write(p.picture_data)}
         end
         picture_name = p.picture_name
      else
         unless FileTest.exist?("public/kiosk_images/slideshow/#{p.picture_name}.jpg")
           image = Magick::Image.from_blob(p.picture_data).first
         
           File.open('public/kiosk_images/slideshow/'+p.picture_name+'.jpg','w'){|f| f.write(image.to_blob{self.format = "jpg"})}
         end
         picture_name = p.picture_name+'.jpg'
      end
      
      
      unless p.features.empty?
      
        for f in p.features
          # add features to left and right of phone
        end
      
      end
      
      xml += "<image img='/kiosk_images/slideshow/"+picture_name+"' caption='Buy Outright for $"+p.buy_price.to_s+"' />\r\n"
    
    end
    
    xml += "</slideshow>\r\n"
    
    local_filename = 'public/xml/plasma.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end

end