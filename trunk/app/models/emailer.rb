class Emailer < ActionMailer::Base
  def to_customer(id)
    @recipients   = "softwud@softwud.com"
    @from         = "chris@sharpwebservice.com"
    headers         "Reply-to" => "chris@sharpwebservice.com"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    body[:id]  = id
  end

  def to_service_rep(id)
    @recipients   = "softwud@softwud.com"
    @from         = "chris@sharpwebservice.com"
    headers         "Reply-to" => "chris@sharpwebservice.com"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
    body[:id]  = id
  end
end
