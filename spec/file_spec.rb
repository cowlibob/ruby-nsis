require 'helper'
include NSIS

describe "File Tasks" do
  before(:each) do
    Builder::config do
      base_path = 'examples/source'
    end
  end
  
  it "should output simple file task" do
    Builder::script do
      file 'file.ext'
    end.output.should == "File file.ext"
  end
  
  it "should output a simple file using specified name" do
    Builder::script do
      file 'file.ext', :as => 'renamed_file.ext'
    end.output.should == "File /oname=\"renamed_file.ext\" file.ext"
  end
  
  it "should output multiple files" do
    Builder::script do
      file 'file1.ext'
      file 'file2.ext'
    end.output.should == "File file1.ext\nFile file2.ext"
  end
  
  it "should output multiple files, including renames" do
    Builder::script do
      file 'file1.ext', :as => 'renamed_file1.ext'
      file 'file2.ext', :as => 'renamed_file2.ext'
    end.output.should == "File /oname=\"renamed_file1.ext\" file1.ext\nFile /oname=\"renamed_file2.ext\" file2.ext"
  end
  
  it "should throw an exception if multiple files are specified with rename" do
    lambda do
      Builder::script do
        file '*', :as => 'dir\*'
      end
    end.should raise_error(Builder::BadParameterError)
  end
  
  it "should exclude specified files" do
    Builder::script do
      file '*.ext', :not => 'dont_include.*'
    end.output.should == "File /x dont_include.* *.ext"
  end
  
  it "should support recursive files" do
    Builder::script do
      file 'data', :recurse => true
    end.output.should == "File /r data"
  end
  
  it "should support missing files" do
    Builder::script do
      file '"a file that might not exist"', :nonfatal => true
    end.output.should == 'File /nonfatal "a file that might not exist"'
  end
  
  it "should handle complex combinations" do
    Builder::script do
      file 'myproject\*.*', :recurse => true, :not => 'CVS'
    end.output.should == 'File /r /x CVS myproject\*.*'
    
    Builder::script do
      file 'source\*.*', :recurse => true, :not => ['*.res', '*.obj', '*.pch']
    end.output.should == 'File /r /x *.res /x *.obj /x *.pch source\*.*'
  end
  
  
end
