require 'helper'
include NSIS

describe "Echo Task" do
  it "should copy input to output script verbatim" do
    Builder::script do
      echo 'DeleteRegValue HKLM "Software\My Company\My Software" "some value"'
    end.output.should == 'DeleteRegValue HKLM "Software\My Company\My Software" "some value"'
  end
  
  it "should accept multiple parameters, all of which are echoed to the nsis script" do
    Builder::script do
      echo 'DeleteRegValue', 'HKLM', '"Software\My Company\My Software"', '"some value"'
    end.output.should == 'DeleteRegValue HKLM "Software\My Company\My Software" "some value"'
  end
end