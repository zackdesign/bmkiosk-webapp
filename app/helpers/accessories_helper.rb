module AccessoriesHelper
  
  ##
  # used in accessories/show.rhtml
  def show_picture_if_available(accessory)
    unless accessory.picture_data.blank?
      link_to(image_tag(url_for({ :action => 'picture', :id => accessory.id }), { :alt => accessory.picture_name, :border => 0, :class => "medium" }), url_for({ :action => 'actual', :id => accessory.id }), :popup => true)
    else
      content_tag(:span, "None")
    end
  end
  
  ##
  # used in accessories/list.rhtml
  def show_thumbnail_if_available(accessory)  
    unless accessory.picture_name.blank?
      thumb = { :action => 'thumbnail', :id => accessory.id }
      image_tag(url_for(thumb), :alt => accessory.picture_name, :class => "thumb", :width=>thumb.columns, :height=>thumb.rows)
    else
      content_tag(:span, "None")
    end
  end
  
  def link_to_archive_action(accessory)
    if params[:action] == 'listarch'
      link_to('Unarchive', { :action => 'unarchive', :id => accessory }, :confirm => "Unarchive this accessory ?", :method => :post)
    else
      confirm_message = accessory.phones.empty? ? "Archive this accessory ?" : "WARNING: This accessory is still used by #{accessory.phones.count} phone(s).\n\nArchive this accessory ?"
      link_to('Archive', { :action => 'archive', :id => accessory }, :confirm => confirm_message, :method => :post)
    end
  end
  
  def link_to_delete(accessory)
    confirm_message = accessory.phones.empty? ? "Permanently delete this accessory ?" : "WARNING: Deleting this accessory will also delete it from #{accessory.phones.count} phone(s).\n\nPermanently delete this accessory ?"
    action_name = params[:action] == 'listarch' ? 'deletearch' : 'delete'
    link_to image_tag('delete', :alt => 'delete'), { :action => action_name, :id => accessory }, :confirm => confirm_message, :class => 'icon', :title => 'delete', :method => :post
  end
  
  def link_to_accessory_phones(accessory)
    if accessory.phones.count > 0
      link_to(accessory.phones.count, "#accessory#{accessory.id}_phones", :class => "modal") + list_related_phones(accessory)
    else
      content_tag(:span, accessory.phones.count)
    end
  end
  
  def show_offer_picture_if_available(accessory)
    unless accessory.picture_data.blank?
      link_to(image_tag(url_for({ :action => 'offer_picture', :id => accessory.id }), { :alt => accessory.picture_name, :border => 0, :class => "medium" }), url_for({ :action => 'actual', :id => accessory.id }), :popup => true)
    else
      content_tag(:span, "None")
    end
  end
  
  private
  def list_related_phones(accessory)
    result = ""
    accessory.phones.each{|p| result << content_tag(:li, p.name)}
    content_tag(:div, content_tag(:ul, result), :id => "accessory#{accessory.id}_phones")
  end
end
