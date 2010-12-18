require 'helper'
include NSIS

describe "Rename task" do
  
  it "should rename a file" do
    Builder.script do
      rename '$INSTDIR\file.ext', '$INSTDIR\file.dat'
    end.output.should == 'Rename $INSTDIR\file.ext $INSTDIR\file.dat'
  end
  
  it "should allow reboot to remove files in use" do
    Builder.script do
      rename '$INSTDIR\file.ext', '$INSTDIR\file.dat', :allow_reboot => true
    end.output.should == 'Rename /REBOOTOK $INSTDIR\file.ext $INSTDIR\file.dat'
  end  
  
end