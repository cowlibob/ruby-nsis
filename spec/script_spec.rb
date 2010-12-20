require 'helper'
require 'pp'
include NSIS

describe "NSIS::Builder::Script" do
  it "should store a file and line number for each generated nsis instruction" do
    s = Builder::script do
      file '*.ext'
      rename 'old.ext', 'new.ext'
    end
    
    s.sources.should be_a_kind_of(Array)
    s.sources.should have_at_least(2).lines
    
    s.commands.should be_a_kind_of(Array)
    s.commands.should have_at_least(2).lines
    
  end
    
end