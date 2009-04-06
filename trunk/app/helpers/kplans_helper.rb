module KplansHelper
  def show_thumbnail_if_available(phone)
    unless phone.picture_name.blank?
      image_tag(url_for({ :action => 'thumbnail', :id => phone.id }), :alt => phone.name, :class => "thumb")
    end
  end
  
end
