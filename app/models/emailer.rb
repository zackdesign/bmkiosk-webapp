class Emailer < ActionMailer::Base
  def to_customer(id)
    @recipients   = "isaac@zackdesign.biz"
    @from         = "carla@bmtronics.com.au"
    headers         "Reply-to" => "carla@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    body[:id]  = id
  end

  def to_service_rep(id)
    @recipients   = "isaac@zackdesign.biz"
    @from         = "carla@bmtronics.com.au"
    headers         "Reply-to" => "carla@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    body[:id]  = id
    body[:user_cart] = @cart
  end
end
