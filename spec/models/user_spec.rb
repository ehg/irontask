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

  it "is invalid without a password salt" do
    @user.salt = nil
    @user.should_not be_valid
  end

  it "is invalid if the username is over 50 characters" do
    @user.username = "testtesttesttesttesttesttesttesttesttesttesttesttesttest"
    @user.should_not be_valid
  end

  it "says that a correct username and password is correct" do
    @user.save!
    User.valid_details?("test", "testing").should be_true
  end

 
  it "says that an incorrect username and password is incorrect" do
    @user.save!
    User.valid_details?("wrong", "wrongpassword").should be_false
  end
  
end
