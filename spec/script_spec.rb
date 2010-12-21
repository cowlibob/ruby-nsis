require 'helper'
include NSIS

describe "NSIS::Builder::Script" do
  it "should store a file and line number for each generated nsis instruction" do
    s = Builder::script do
      file '*.ext'
      rename 'old.ext', 'new.ext'
    end
    
    s.input_lines.should be_a_kind_of(Array)
    s.input_lines.should have_at_least(2).lines
    s.input_lines.first.to_s.match(/#{__FILE__}:\d+/).should_not be_nil
    
    s.output_lines.should be_a_kind_of(Array)
    s.output_lines.should have_at_least(2).lines
    
  end
    
end