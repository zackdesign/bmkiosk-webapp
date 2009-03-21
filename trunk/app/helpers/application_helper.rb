# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def show_latest_accessories(options={:max => 10})
  
    max = options[:max]
    
    accessories = Accessory.find(:all, :order => "created_at DESC", :limit => max)
    
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
            link = link_to "#{a.name}", :controller=>'phones',:action => 'show', :id => a.id
            "<li>#{link}</li>"
          }
          
    return list
  
  end
  
  def show_popular_phones(options={:max => 10})
    
      max = options[:max]
      
      phones = Phone.find_by_sql('SELECT p.id, p.name
                                  FROM kiosks AS k, phones AS p
                                  WHERE k.kiosk < "4"
                                  AND p.id = k.phone_id                                  
                                  ORDER BY p.name ASC
                                  LIMIT ' + max.to_s )
      
      list = phones[0...phones.length].map { |a|
              link = link_to "#{a.name}", :controller=>'phones',:action => 'show', :id => a.id
              "<li>#{link}</li>"
            }
            
      return list
    
  end
  
  def upfront_cost(phone, plan)
    
    period  = plan.period.split(',')
    phone.outright
      
      
    return plan.name
  end

end
