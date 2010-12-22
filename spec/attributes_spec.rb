require 'helper'
include NSIS

describe NSIS::Configuration do
  before(:each) do
    @builder_config = Builder.config do
      branding_image :position => :left, :width => 100, :padding => 2, :source => 'branding.bmp'
      gui_init 'MessageBox MB_OK "Hello world!"'
    end
  end
  
  it "should store the branding image details for later use" do
    @builder_config.branding_image.should == {:position => :left, :width => 100, :padding => 2, :source => 'branding.bmp'}
  end
  
  it "should output the AddBrandingImage instruction in the root of the script" do
    @builder_config.output_attributes.should include("AddBrandingImage left 100 2")
  end
  
  it "should output a string for any valid callback" do
    @builder_config.output_callback(:gui_init).should be_an_instance_of(String)
  end
  
  it "should output the SetBrandingImage in the .onGUIInit callback" do
    @builder_config.output_callback(:gui_init).should include('SetBrandingImage "$TEMP\branding.bmp"')
  end
  
  it "should append custom NSIS instructions to the .onGUIInit callback" do
    @builder_config.output_callback(:gui_init).should include('MessageBox MB_OK "Hello world!"')
  end
end