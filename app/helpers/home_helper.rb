module HomeHelper

  require 'RMagick'
  include Magick
  
  include ActionView::Helpers::NumberHelper

    def display_phones()
        
        phones = Phone.find_by_sql('SELECT p.id, p.name, picture_name, p.picture_data
                                    FROM kiosks AS k, phones AS p
                                    WHERE k.kiosk < "4"
                                    AND p.id = k.phone_id                                  
                                    ORDER BY p.created_at DESC
                                    LIMIT 3')
        
        count=1
        list = ''
        
        for p in phones
        
          unless p.picture_name.nil?
        
        picture = p.picture_name+'.jpg'
        
               image = Magick::Image.from_blob(p.picture_data).first
	        
	        max_dimension = (image.columns < image.rows) ? image.rows : image.columns
	          if max_dimension < 80
	            thumb = image
	          else
	            thumb = image.resize_to_fit(80, 150)
	        end
		
		wet = thumb.wet_floor(initial=0.5, rate=0.1)
		          wet.resize!(wet.columns, wet.rows/3)
		
		          final = Magick::Image.new(thumb.columns, thumb.rows+wet.rows)
		          final = final.composite(wet, SouthGravity, OverCompositeOp)
          final = final.composite(thumb, NorthGravity, OverCompositeOp)
	        
          File.open('public/bmweb/phones/'+picture,'w'){|f| f.write(final.to_blob{self.format = "jpg"})}
          end
          link = link_to image_tag('/bmweb/phones/'+picture, :alt=>p.name), :controller=>'phones',:action => 'show', :id => p.id
          
          more = link_to '<strong>More &raquo;</strong>&nbsp;', :controller=>'phones',:action => 'show', :id => p.id
          
          if count == 1
            list += '
            <div class="box2_row1">'
          end
          
          list += "
          <div class='shop_handset#{count}_img'>#{link}</div>
              <div class='shop_handset#{count}'>
                <div class='shop_handset_title' style='padding-top:4px;'>#{p.name}</div>
                <div class='shop_handset_desc'></div>
                <div class='shop_handset_foot'>
                  <!--<div class='shf_nextg'><img src='/bmweb/nextg_sml_reflect.gif' alt='NextG' width='28' height='40' /></div>-->
                  <div class='shf_more'>#{more}</div>

                </div>
              </div>"
          count += 1;
          if count >= 4
            count = 1;
            
            list += '            
	            </div>
                    '  
          end
        end
        
        return list
      
  end
  
      def display_accessories()
          
          acc = Accessory.find_by_sql('SELECT p.id, p.name, p.picture_name, p.picture_data
                                      FROM accessories AS p                                
                                      ORDER BY p.created_at DESC
                                      LIMIT 3')
          
          count=1
          list = ''
          
          for p in acc
          
            unless p.picture_name.nil?
          
          picture = p.picture_name+'.jpg'
          
                 image = Magick::Image.from_blob(p.picture_data).first
  	        
  	        max_dimension = (image.columns < image.rows) ? image.rows : image.columns
  	          if max_dimension < 80
  	            thumb = image
  	          else
  	            thumb = image.resize_to_fit(80, 150)
  	        end
  		
  		wet = thumb.wet_floor(initial=0.5, rate=0.1)
  		          wet.resize!(wet.columns, wet.rows/3)
  		
  		          final = Magick::Image.new(thumb.columns, thumb.rows+wet.rows)
  		          final = final.composite(wet, SouthGravity, OverCompositeOp)
            final = final.composite(thumb, NorthGravity, OverCompositeOp)
  	        
            File.open('public/bmweb/phones/'+picture,'w'){|f| f.write(final.to_blob{self.format = "jpg"})}
            end
            link = link_to image_tag('/bmweb/phones/'+picture, :alt=>p.name), :controller=>'accessories',:action => 'show', :id => p.id
            
            more = link_to '<strong>More &raquo;</strong>&nbsp;', :controller=>'accessories',:action => 'show', :id => p.id
            
            if count == 1
              list += '
              <div class="box2_row2">'
            end
            
            list += "
            <div class='shop_handset#{count}_img'>#{link}</div>
                <div class='shop_handset#{count}'>
                  <div class='shop_handset_title' style='padding-top:4px;'>#{p.name}</div>
                  <!--<div class='shop_handset_desc'>short desc</div>-->
                  <div class='shop_handset_foot'>
                    <!--<div class='shf_nextg'><img src='/bmweb/nextg_sml_reflect.gif' alt='NextG' width='28' height='40' /></div>-->
                    <div class='shf_more_2'>#{more}</div>
  
                  </div>
                </div>"
            count += 1;
            if count >= 4
              count = 1;
              
              list += '            
  	            </div>
                      '  
            end
          end
          
          return list
        
  end

end