# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_latest_accessories(options={:max => 10})
  
    max = options[:max]
    
    accessories = Accessory.find_by_sql('SELECT p.id, p.name
                                    FROM featured_accessories AS f, accessories AS p
                                    WHERE p.id = f.accessory_id AND f.atype = "latest" AND outofstock = "0" AND discontinued = "0" AND active = "1"
                                    ORDER BY p.name
                                    LIMIT '+max.to_s)
    
    list = accessories[0...accessories.length].map { |a|
            link = link_to "#{a.name}", :controller=>'accessories',:action => 'show', :id => a.id
            "<li>#{link}</li>"
          }
          
    return list
  
  end
  
  def show_latest_phones(options={:max => 10})
  
    max = options[:max]
    
    phones = Phone.find(:all, :conditions => "outofstock = '0' AND discontinued = '0'", :order => "created_at DESC", :limit => max)
    
    list = phones[0...phones.length].map { |a|
            link = link_to "#{a.brand} #{a.name}", :controller=>'phones',:action => 'show', :id => a.id
            "<li>#{link}</li>"
          }
          
    return list
  
  end
  
  def show_popular_phones(options={:max => 10})
    
      max = options[:max]
      
      phones = Phone.find_by_sql('SELECT p.id, p.name, p.brand
                                  FROM phones AS p          
						    WHERE outofstock = "0" AND discontinued = "0"
                                  ORDER BY p.popularity DESC
                                  LIMIT ' + max.to_s )
      
      list = phones[0...phones.length].map { |a|
              link = link_to "#{a.brand} #{a.name}", :controller=>'phones',:action => 'show', :id => a.id
              "<li>#{link}</li>"
            }
            
      return list
    
  end
  
  def show_popular_accessories(options={:max => 10})
    
      max = options[:max]
      
      accessories = Accessory.find_by_sql('SELECT p.id, p.name
                                  FROM accessories AS p     
						    WHERE outofstock = "0" AND discontinued = "0" AND active = "1"                      
                                  ORDER BY p.popularity DESC
                                  LIMIT ' + max.to_s )
      
      list = accessories[0...accessories.length].map { |a|
              link = link_to "#{a.name}", :controller=>'accessories',:action => 'show', :id => a.id
              "<li>#{link}</li>"
            }
            
      return list
    
  end
  
  def upfront_cost(phone, plan)
    
    period  = plan.period.split(',')
    phone.outright
      
      
    return plan.name
  end
  
  def show_shop_logo(logo_name, alt)
    image_tag(url_for({ :action => 'return_logo', :name=> logo_name }), :alt => alt)
  end
  


end
