class StoreController < ApplicationController
  require 'RMagick'
  include Magick

  protect_from_forgery :only => [:create, :update, :destroy] 
  layout 'bmweb'

  def saveorder
    save_order()
  end

  def cartdel
    unless request.xhr?
      return
    end

    begin
      product = Product.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      flash[:notice] = "Invalid product"
      redirect_to(:action => "index") unless request.xhr? and return
    else
      remove_from_cart
#      product.destroy
    end
  end

  def emptycart
    unless request.xhr?
      return
    end

    unless @cart.items.empty?
      empty_cart
    end
  end

end