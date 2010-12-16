require 'helper'

describe "File Tasks" do
  it "should output simple file task" do
    NSIS::script do
      file 'file.ext'
    end.output.should == "File file.ext"
  end
  
  it "should output a simple file using specified name" do
    NSIS::script do
      file 'file.ext', :as => 'renamed_file.ext'
    end.output.should == "File /oname=renamed_file.ext file.ext"
  end
  
  it "should output multiple files" do
    NSIS::script do
      file 'file1.ext'
      file 'file2.ext'
    end.output.should == "File file1.ext\nFile file2.ext"
  end
  
  it "should output multiple files, including renames" do
    NSIS::script do
      file 'file1.ext', :as => 'renamed_file1.ext'
      file 'file2.ext', :as => 'renamed_file2.ext'
    end.output.should == "File /oname=renamed_file1.ext file1.ext\nFile /oname=renamed_file2.ext file2.ext"
  end 
  
  it "should exclude specified files" do
    NSIS::script do
      file '*.ext', :not => 'dont_include.*'
    end.output.should == "File /x dont_include.* *.ext"
  end
  
  
end
