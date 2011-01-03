require 'helper'
include NSIS

describe "Macro implementation" do
  it "should wrap a given block in a macro if block" do
    Builder::script do
      if_defined? 'HAVE_UPX' do
        echo '!packhdr tmp.dat "upx\upx -9 tmp.dat"'
      end
    end.output.should == <<-EOF
!ifdef HAVE_UPX
  !packhdr tmp.dat "upx\\upx -9 tmp.dat"
!endif
EOF
  end
  
  it "should wrap a given block in a macro if not block" do
    Builder::script do
      if_not_defined? 'NOINSTTYPES' do
        echo 'InstType "Most"'
        echo 'InstType "Full"'
        echo 'InstType "More"'
        echo 'InstType "Base"'
      end
    end.output.should == <<-EOF
!ifndef NOINSTTYPES
  InstType "Most"
  InstType "Full"
  InstType "More"
  InstType "Base"
!endif
EOF
  end
  
  it "should implement !include macro" do
    Builder::script do
      include "test.nsh"
    end.output.should == "!include 'test.nsh'"
  end
  
end