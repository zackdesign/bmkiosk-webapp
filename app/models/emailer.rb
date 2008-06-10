class Emailer < ActionMailer::Base

  def emailer(id)
       
    @recipients   = "chris@sharpwebservice.com"
    @from         = "chris@sharpwebservice.com"
    headers         "Reply-to" => "chris@sharpwebservice.com"
    @subject      = "New web order"
    @sent_on      = Time.now
    @content_type = "text/plain"
 
    body[:id]  = id       
  end


end
