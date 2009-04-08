class Emailer < ActionMailer::Base
  def to_customer(id, order)
    @recipients   = order[:email]
    @from         = "admin@bmtronics.com.au"
    headers         "Reply-to" => "admin@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/html"
    @user =order
    #@order = Order.find(id)
    #@order.add_line_items_from_cart(@cart)
    body[:id]  = id
    body[:user_cart] = @order
  end

  def to_service_rep(id, order)
    @recipients   = "isaac@zackdesign.biz"
    @from         = "admin@bmtronics.com.au"
    headers         "Reply-to" => "admin@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/html"
    @user =order
    #@order = Order.find(id)
    #@order.add_line_items_from_cart(@cart)
    body[:id]  = id
    body[:user_cart] = @order
  end
end
