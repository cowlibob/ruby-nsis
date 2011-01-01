require 'helper'
include NSIS

describe "NSIS::Builder::Script" do
  before(:each) do
    @config = Builder::config do
      base_path File.expand_path('../../test_data/script_spec', __FILE__)
      target 'success_file'
    end
  end
  
  it "should store a file and line number for each generated nsis instruction" do
    script = Builder::script(@config) do
      file '*.ext'
      rename 'old.ext', 'new.ext'
    end
    script.input_lines.should be_a_kind_of(Array)
    script.input_lines.should have_at_least(2).lines
    script.input_lines.first.to_s.match(/#{__FILE__}:\d+/).should_not be_nil
    
    script.output_lines.should be_a_kind_of(Array)
    script.output_lines.should have_at_least(2).lines
    
  end
  
  it "should recieve output of an nsis build" do
    script = Builder::script(@config) do
      echo 'Section'
      file '*.ext'
      rename 'old.ext', 'new.ext'
      echo 'SectionEnd'
    end
    script.build
    script.build_report.should be_an_instance_of String
  end
end
  
describe "A successful build" do
  before(:each) do
    @config = Builder::config do
      base_path File.expand_path('../../test_data/script_spec', __FILE__)
      target 'success_file'
    end
    @script = Builder::script(@config) do
      echo "# successful build"
      echo "Section"
      rename 'old.ext', 'new.ext'
      echo "SectionEnd"
    end
    @script.build
  end
  
  after(:each) do
    @script.clean
  end
  
  it "should have a target file" do
    @config.target.should match(/success_file.exe$/)
  end
  
  it "should recieve a build summary" do
    @script.build_report.should match(/Install: \d+ pages/)
  end
  
  it "should output an executable file" do
    File.exist?(@config.target).should be_true("#{@config.options['target']} missing")
  end
end

describe "An unsuccessful build" do
  before(:each) do
    @config = Builder::config do
      base_path File.expand_path('../../test_data/script_spec', __FILE__)
      target = 'fail'
    end
    @script = Builder::script(@config) do
      echo "# unsuccessful build"
      echo "gobbledegook"
    end
    @script.build
  end
  
  it "should not recieve a build summary" do
    @script.build_report.should_not match(/Install: \d+ pages/)
  end
end
