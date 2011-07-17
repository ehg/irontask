require 'spec_helper'

describe User do
  before :each do
    @user = User.make
  end

  it "is valid with valid attributes" do
    @user.should be_valid
  end

  it "is invalid without a username" do
    @user.username = nil
    @user.should_not be_valid
  end
  
  it "is invalid without a password" do
    @user.password = nil
    @user.should_not be_valid
  end

  it "is invalid if the username is over 50 characters" do
    @user.username = "testtesttesttesttesttesttesttesttesttesttesttesttesttest"
    @user.should_not be_valid
  end

  it "authenticates a user with username and hashed pass" do
    @user.save!
    password = (Digest::SHA2.hexdigest "testing").to_s
    User.authenticate("test", password).should_not be_nil 
  end

 
  it "doesn't authenticate invalid details" do
    @user.save!
    User.authenticate("wrong", "wrongpassword").should be_nil
  end
  
  it "should have a salt generated" do
    @user.save
    @user.salt.should_not be_nil
  end
end
