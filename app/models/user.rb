require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :username, :password, :salt
  validates :username, :length => {:maximum => 50}

  def self.valid_details?(username, password)
    if u = User.find_by_username(username) 
      return (Digest::SHA2.new << password+u.salt).to_s == u.password
    end
    false 
  end
end
