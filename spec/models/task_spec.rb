require 'spec_helper'

describe Task do

  before :each do
    @task = Task.make
  end

  it "should be valid with valid attributes" do
    @task.should be_valid
  end

  it "should not be valid without content" do
    @task.content = nil
    @task.should_not be_valid
  end

  it "should not be valid without a done field" do
    @task.done = nil
    @task.should_not be_valid 
  end

  it "should validate with a false done field" do
    @task.done = false
    @task.should be_valid
  end

  it "saves a record" do
    @task.save.should be_true    
  end

  it "can find all tasks not yet done" do
    2.times { Task.make( :done => false).save! }
    Task.undone_tasks.size.should == 2
  end

  it "can find all tasks marked as done" do
    2.times { Task.make.save! }
    Task.done_tasks.size.should == 2
  end
end
