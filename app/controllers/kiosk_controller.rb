class KioskController < ApplicationController
  
  before_filter :no_cache, :only => [:new]
  
  require 'RMagick'
  include Magick
  
  include ActionView::Helpers::NumberHelper

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
      
      reload = 0
      
      if params[:reload]
        reload = 1
      end
      
      if ((FileTest.exist?("public/kiosk_images/#{picture}") == 0) || (reload == 1))
      
        image = Magick::Image.from_blob(p.picture_data).first
        
        max_dimension = (image.columns < image.rows) ? image.rows : image.columns
          if max_dimension < 220
            thumb = image
          else
            thumb = image.resize_to_fit(220, 220)
        end
        
        caption = Magick::Image.read("caption:"+p.name) { 
	       self.size = "#{thumb.columns}";
	       self.pointsize = 20
	       self.font = 'Arial'
	       self.gravity = CenterGravity
        }.first
        
        unless pos.empty?
            text = Magick::Draw.new
            text.font_family = 'arial'
            text.pointsize = 20
            text.gravity = Magick::CenterGravity
            text.font_weight = 700
            text.rotation = -45
            text.annotate(thumb, 0,0,2.5,2.5, pos) { self.fill = 'gray' }
            text.annotate(thumb, 0,0,2,2, pos) { self.fill = 'black' }
            text.annotate(thumb, 0,0,0,0, pos) { self.fill = 'red' }
        end
        
        big_canvas = Magick::Image.new(thumb.columns, thumb.rows+caption.rows)
	big_canvas = big_canvas.composite(thumb, NorthGravity, OverCompositeOp)
        thumb = big_canvas.composite(caption, SouthGravity, OverCompositeOp)
        
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
    # Check for logos flagged as 'other' to put here also
    
    phones = Phone.find_by_sql('SELECT p.id, p.name, p.picture_type, p.picture_name, p.picture_data, p.buy_price
                                FROM kiosks AS k, phones AS p
                                WHERE k.kiosk = "'+@plasma+'"
                                AND p.id = k.phone_id')
    accessories = Accessory.find(:all, :conditions => {:plasma => '1'})
    logos = Logo.find(:all, :conditions => {:plasma => '1'})
    
    xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\r\n"
    xml += '	<slideshow  displayTime="20" transitionSpeed=".7" transitionType="Fade" motionType="None" motionEasing="easeInOut" randomize="true"
                            slideshowWidth="auto" slideshowHeight="auto" slideshowX="center" slideshowY="center" bgColor="FFFFFF" bgOpacity="100"
                            useHtml="true" showHideCaption="true" captionBg="000000" captionBgOpacity="80" captionTextSize="20" captionTextColor="FFFFFF"
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
				imageScaling="downFit"
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
      
      picture = p.picture_name+'.jpg'
      
      unless FileTest.exist?("public/kiosk_images/slideshow/#{picture}") || params[:reload]
         
         montage = ''
         
         unless p.features.empty?
             
             ilist = Magick::ImageList.new
             
	     for f in p.features
	        ilist.from_blob(f.picture_data) 
	        ilist.cur_image[:Label] = f.name
	     end
	     
	     montage = ilist.montage{background_color='white', self.geometry='100x100+2+2', self.pointsize=10, self.tile='2x30'}
         end
         
         image = Magick::Image.from_blob(p.picture_data).first
         
         if p.buy_price        
	   price = ' - '+number_to_currency(p.buy_price)
	 else
	   price = ''
         end
         
         text = Magick::Image.read("caption:"+p.name+price) { 
	 	            self.size = "#{image.columns+220}";
	 	            self.pointsize = 35
	 	            self.gravity = SouthGravity
	 	            self.font = 'Arial'
         }.first
         
         big_canvas = Magick::Image.new(image.columns+220, image.rows+text.rows)
         big_canvas = big_canvas.composite(image, NorthEastGravity, OverCompositeOp)
         unless montage.empty?
           big_canvas = big_canvas.composite(montage, NorthWestGravity, OverCompositeOp)
         end
         big_canvas = big_canvas.composite(text, SouthGravity, OverCompositeOp)
         
         wet = big_canvas.wet_floor(initial=0.5, rate=0.1)
         wet.resize!(wet.columns, wet.rows/3)
         
         final = Magick::Image.new(big_canvas.columns, big_canvas.rows+wet.rows)
         final = final.composite(wet, SouthGravity, OverCompositeOp)
         final = final.composite(big_canvas, NorthGravity, OverCompositeOp)
                  
         File.open('public/kiosk_images/slideshow/'+picture,'w'){|f| f.write(final.to_blob{self.format = "jpg"})}
      end
      
      xml += "<image img='/kiosk_images/slideshow/"+picture+"' caption='' />\r\n"
    
    end
    
    for a in accessories
      
      picture = a.picture_name+'.jpg'
      
      unless FileTest.exist?("public/kiosk_images/slideshow/#{picture}") || params[:reload]
                  
         image = Magick::Image.from_blob(a.picture_data).first
         
         if a.buy_price        
	   price = ' - '+number_to_currency(a.buy_price)
	 else
	   price = ''
         end
         
         text = Magick::Image.read("caption:"+a.name+price) { 
	            self.size = "#{image.columns}";
	            self.pointsize = 20
	            self.font = 'Arial'
         }.first
         
         big_canvas = Magick::Image.new(image.columns, image.rows+text.rows)
         big_canvas = big_canvas.composite(image, NorthEastGravity, OverCompositeOp)
         big_canvas = big_canvas.composite(text, SouthGravity, OverCompositeOp)
         
         wet = big_canvas.wet_floor(initial=0.5, rate=0.1)
         wet.resize!(wet.columns, wet.rows/3)
         
         final = Magick::Image.new(big_canvas.columns, big_canvas.rows+wet.rows)
         final = final.composite(wet, SouthGravity, OverCompositeOp)
         final = final.composite(big_canvas, NorthGravity, OverCompositeOp)
                  
         File.open('public/kiosk_images/slideshow/'+picture,'w'){|f| f.write(final.to_blob{self.format = "jpg"})}
      end
      
      xml += "<image img='/kiosk_images/slideshow/"+picture+"' caption='' />\r\n"
    
    end

    for l in logos
      
      picture = l.picture_name+'.jpg'
      
      unless FileTest.exist?("public/kiosk_images/slideshow/#{picture}") || params[:reload]
                  
         image = Magick::Image.from_blob(l.picture_data).first
         
         big_canvas = Magick::Image.new(image.columns, image.rows)
         big_canvas = big_canvas.composite(image, NorthEastGravity, OverCompositeOp)
         
         wet = big_canvas.wet_floor(initial=0.5, rate=0.1)
         wet.resize!(wet.columns, wet.rows/3)
         
         final = Magick::Image.new(big_canvas.columns, big_canvas.rows+wet.rows)
         final = final.composite(wet, SouthGravity, OverCompositeOp)
         final = final.composite(big_canvas, NorthGravity, OverCompositeOp)
                  
         File.open('public/kiosk_images/slideshow/'+picture,'w'){|f| f.write(final.to_blob{self.format = "jpg"})}
      end
      
      xml += "<image img='/kiosk_images/slideshow/"+picture+"' caption='' />\r\n"
    
    end
    
    xml += "</slideshow>\r\n"
    
    local_filename = 'public/xml/plasma.xml'
    
    File.open(local_filename,'w'){|f| f.write(xml)}
    
  end

end