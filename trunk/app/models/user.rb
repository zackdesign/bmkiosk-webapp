require 'digest/sha1'


class User < ActiveRecord::Base
  
  validates_presence_of     :name
  validates_uniqueness_of   :name
 
  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end

  
  
  def self.authenticate(password)
    @all_users = User.find(:all)
    user2 = nil
    for user in @all_users
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password == expected_password
        user2 = user
      end
    end
    user2
  end
  
  
  # 'password' is a virtual attribute
  
  def password
    @password
  end
  
  def password=(pwd)
    @password = pwd
    return if pwd.blank?
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end
  
    
  def after_destroy
    if User.count.zero?
      raise "Can't delete last user"
    end
  end   
  
    
  def showtype(ut)
     case ut
       when "1"    then return "Admin"
       when "2"    then return "Business"
       when "3"    then return "User"
       else return "Unknown"
     end 

  end      
  
  
  private
  
  def self.encrypted_password(password, salt)
    string_to_hash = password + "wibble" + salt  # 'wibble' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end
  


  
  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end
  

end
