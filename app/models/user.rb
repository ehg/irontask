require 'digest/sha1'

class User < ActiveRecord::Base
  validates_presence_of :username, :password, :salt
  validates :username, :length => {:maximum => 50}, :uniqueness => true
  before_validation :generate_salt

  def self.authenticate(username, password)
    return nil unless user = User.find_by_username(username) 
    return user if (Digest::SHA2.new << password+user.salt).to_s == user.password
  end

  def generate_salt
    self.salt = (Digest::SHA2.new << rand(9999999999).to_s).to_s if self.new_record?
  end
end
