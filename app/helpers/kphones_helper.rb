module KphonesHelper
  def show_feature_thumbnail_if_available(feature)
        unless FileTest.exist?("public/db_images/features/#{feature.picture_name}")
          image = Magick::Image.from_blob(feature.picture_data).first
          
          max_dimension = (image.columns < image.rows) ? image.rows : image.columns
                    if max_dimension < 50
                      thumb = image
                    else
                      thumb = image.resize_to_fit(50, 50)
          end
          
          File.open('public/db_images/features/'+feature.picture_name,'w'){|f| f.write(thumb.to_blob)}
    end
    
    image_tag("/db_images/features/"+feature.picture_name)
  end
  
  def show_phone_thumbnail_if_available(phone)
    
     unless FileTest.exist?("public/db_images/features/#{phone.picture_name}")
          image = Magick::Image.from_blob(phone.picture_data).first
          
          max_dimension = (image.columns < image.rows) ? image.rows : image.columns
                    if max_dimension < 300
                      thumb = image
                    else
                      thumb = image.resize_to_fit(300,300)
          end
          
          File.open('public/db_images/phones/'+phone.picture_name,'w'){|f| f.write(thumb.to_blob)}    end
    
    image_tag("/db_images/phones/"+phone.picture_name)
  
  end
end