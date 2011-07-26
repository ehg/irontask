require 'digest/sha1'

class User < ActiveRecord::Base
  has_many :tasks

  validates_presence_of :username, :password
  validates :username, :length => {:maximum => 50}, :uniqueness => true
  before_save :generate_salt

  def self.authenticate(username, password)
    return nil unless user = User.find_by_username(username) 
    return user if (Digest::SHA2.new << password+user.salt).to_s == user.password
  end

  def generate_salt
    self.salt = (Digest::SHA2.new << rand(9999999999).to_s).to_s if self.new_record? and self.salt.nil?
    self.password = (Digest::SHA2.new << self.password+self.salt).to_s if self.new_record? and self.password
  end
end
