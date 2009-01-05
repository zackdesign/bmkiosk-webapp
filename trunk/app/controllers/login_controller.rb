class LoginController < ApplicationController
  require 'RMagick'
  include Magick

  layout 'personal'

  
  
  before_filter :find_cart, :except => :empty_cart
  before_filter :authorize, :except => [:login, :logout]
  
  def index
    @all_users = User.find(:all)
  end
  

  # just display the form and wait for user to
  # enter a name and password
  
  def login
    session[:user_id] = nil
    session[:user_type] = nil
    if request.post?
      user = User.authenticate(params[:password])
      if user
        session[:user_id] = user.id
        session[:user_type] = user.usertype
        uri = session[:original_uri]
        session[:original_uri] = nil
        
        case user.usertype.to_i
#         when "1"    then redirect_to(uri || { :action => "index" })
#         when "2"    then redirect_to(:controller => "phones" , :action => "index" )
#         when "3"    then redirect_to(:controller => "phones" , :action => "index" )
#         else return "Unknown"
          when 1      then redirect_to(uri || { :action => "index" })
          when 2 .. 4 then redirect_to(:controller => "phones" , :action => "index" )
#          when 3      then redirect_to(:controller => "phones" , :action => "index" )
#          when 4      then redirect_to(:controller => "phones" , :action => "index" )
          else return "Unknown"
        end 
      else
        flash.now[:notice] = "Invalid password..."
      end
    end
  end
  

  
  def add_user
    @user = User.new(params[:user])
    if request.post? and @user.save
      flash.now[:notice] = "User #{@user.name} created"
      @user = User.new
    end
  end

  # . . .
  

  def delete_user
    id = params[:id]
    if id && user = User.find(id)
      begin
        user.destroy
        flash[:notice] = "User #{user.name} deleted"
      rescue Exception => e
        flash[:notice] = e.message
      end
    end
    redirect_to(:action => :list_users)
  end

  def list_users
    @all_users = User.find(:all)
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login")
  end
  
  
  private
  
  def find_cart
    @cart = (session[:cart] ||= Cart.new)
  end

end