require 'helper'
include NSIS

describe "NSIS::Config" do
  it "should return an object of type NSIS::Configuration" do
    Builder.config{}.should be_an_instance_of(Builder::Configuration)
  end
  
  it "should respond to a query for base_path" do
    Builder.config{}.should respond_to(:base_path)
  end
  
  it "should accept and return a base_path from which source files will be found" do
    Builder.config do
      base_path "~/harmony/"
    end.base_path.should == "~/harmony/"
  end
  
  it "should accept and return a target to which the installer executable will be written" do
    Builder.config do
      target "ruby-nsis-test"
    end.target.should include("ruby-nsis-test.exe")
  end
end