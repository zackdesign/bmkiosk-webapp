class Emailer < ActionMailer::Base
  def to_customer(user,order)
    @recipients   = user[:email]
    @from         = "admin@bmtronics.com.au"
    headers         "Reply-to" => "admin@bmtronics.com.au"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/html"
    body :order => order, :user => user
  end

  def to_service_rep(user, order)
    @recipients   = "isaac@zackdesign.biz"
    @from         = user[:email]
    headers         "Reply-to" => user[:email]
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/html"
    body :order => order, :user => user
  end
end
