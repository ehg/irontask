require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :username, :password, :salt
  validates :username, :length => {:maximum => 50}

  def self.authenticate(username, password)
    return nil unless user = User.find_by_username(username) 
    return user if (Digest::SHA2.new << password+user.salt).to_s == user.password
  end

end
