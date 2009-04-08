class Emailer < ActionMailer::Base
  def to_customer(id, order)
    @recipients   = order[:email]
    @from         = "carla@bmtronics.com.au"
    headers         "Reply-to" => "carla@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    @cart  = Cart.find(id)
    body[:id]  = id
    body[:user_cart] = @cart
  end

  def to_service_rep(id, order)
    @recipients   = "isaac@zackdesign.biz"
    @from         = "carla@bmtronics.com.au"
    headers         "Reply-to" => "carla@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    @cart  = Cart.find(id)
    body[:id]  = id
    body[:user_cart] = @cart
  end
end
