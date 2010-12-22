module NSIS
  class Configuration
    attr_reader :options
    Properties = [:base_path, :branding_image, :gui_init]
    def initialize
      @options = {}
    end
    
    # Add accessor method for each property, which takes a parameter to set and none to get.
    Properties.each do |attr|
      code = """
      def #{attr}(value = nil)
        value.nil? ? @options[:#{attr}] : @options[:#{attr}] = value
      end"""
      class_eval(code)
    end
    
    # Generates a string containing NSIS installer attributes.
    # These are generally positioned at the beginning of an NSIS script.
    def output_attributes
      o = Properties.collect do |property|
        method = "output_#{property}".to_sym
        send(method) if private_methods.include?(method)
      end 
      o.join("\n")
    end
    
    # Generates a string containing the definition for the NSIS .onGUIInit function.
    # This is called before the GUI is displayed, and is useful for setting the branding image etc.
    #
    # Note that in our implementation, we allow for a property to be set containing custom code for
    # each callback.
    # For example:
    #  Builder.config do
    #    branding_image :position => :left, :width => 100, :padding => 2, :source => 'branding.bmp'
    #  end
    #  config.gui_init = <<-EOS
    #     # 1028 is the id of the branding text control
    #     GetDlgItem $R0 $HWNDPARENT 1028
    #     CreateFont $R1 "Tahoma" 10 700
    #     SendMessage $R0 ${WM_SETFONT} $R1 0
    #     # set background color to white and text color to red
    #     SetCtlColors $R0 FFFFFF FF0000
    #  EOS
    #
    # would yield the following .onGUIInit code:
    #
    #  Function .onGUIInit
    #    SetOutPath "$TEMP"
    #    SetFileAttributes #{filename} temporary
    #    File "#{branding_image[:source]}"
    #    SetBrandingImage "$TEMP\\#{filename}"
    #    # 1028 is the id of the branding text control
    #    GetDlgItem $R0 $HWNDPARENT 1028
    #    CreateFont $R1 "Tahoma" 10 700
    #    SendMessage $R0 ${WM_SETFONT} $R1 0
    #    # set background color to white and text color to red
    #    SetCtlColors $R0 FFFFFF FF0000
    #  FunctionEnd
    
    def output_callback name
      o = []
      o << case name
        when :gui_init
          filename = File.basename(branding_image[:source])
          <<-EOS
            Function .onGUIInit
              SetOutPath "$TEMP"
              SetFileAttributes #{filename} temporary
              File "#{branding_image[:source]}"
              SetBrandingImage "$TEMP\\#{filename}"
              #{@options[name]}
            FunctionEnd
          EOS
          
      end
      o.join("\n")
    end
        
    
    def output_branding_image
      "AddBrandingImage #{branding_image[:position]} #{branding_image[:width]} #{branding_image[:padding]}"
    end
    private :output_branding_image
  end
end