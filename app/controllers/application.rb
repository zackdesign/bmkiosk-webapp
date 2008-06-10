# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  :secret => 'b89eb255dfa0156f82cb01312d7c1a8e'


 
  
  before_filter :find_cart, :except => :empty_cart

  def index
    @products = Product.find_products_for_sale
  end
  
  
  def add_to_cart(id)
    begin                     
      product = Product.find(id)  
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{id}")
      redirect_to_index("Invalid product")
    else
      @current_item = @cart.add_product(product)
      #redirect_to_index("Added to cart") unless request.xhr?         
    end
  end
  
  def remove_from_cart
    begin                     
      product = Product.find(params[:id])  
    rescue ActiveRecord::RecordNotFound
      logger.error("Attempt to access invalid product #{params[:id]}")
      redirect_to_index("Invalid product")
    else
      @current_item = @cart.remove_product(product)
      redirect_to_index unless (request.xhr? || hide == 1)     
    end
  end

  def empty_cart
    session[:cart] = nil
    redirect_to_index("Your cart is empty")
  end
  
  def checkout
    if @cart.items.empty?
      redirect_to_index("Your cart is empty")
    else
      @order = Order.new
    end
  end
  
  def save_order    
    @order = Order.new(params[:order])   
    @order.add_line_items_from_cart(@cart)
    if @order.save                       
      session[:cart] = nil
      last_id = ActiveRecord::Base.connection.select_value("SELECT id FROM orders WHERE id = LAST_INSERT_ID()")
      Emailer.deliver_emailer(last_id)
      redirect_to_index("Thank you for your order, a sales person will contact you to process the order.")
      
    else
      render :action => :checkout
    end
  end

  private
  
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end
  
  def redirect_to_index(msg = nil)
    flash[:notice] = msg
    redirect_to(:controller => "" , :action => "index" )
  end

  
  def authorize
    user = User.find_by_id(session[:user_id])
    if user
      if session[:user_type] != "1"
        redirect_to(:controller => "phones" , :action => "index", :id => session[:user_type] )
      end
    else
      flash[:notice] = "Please log in..."
      redirect_to(:controller => "login" , :action => "login" )
    end
  end

end
