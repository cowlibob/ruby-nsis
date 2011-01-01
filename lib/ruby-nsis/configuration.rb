# encoding: utf-8

module NSIS
  class Configuration
    attr_reader :options
    
    Callbacks = [:gui_init]
    
    def initialize
      @options = {'base_path' => Dir.pwd, 'target' => 'installer'}
      @branding_image = {}
    end
    
    Properties = [:base_path, :branding_image, :target]
    
    def set value
      unless value.nil?
        param = caller[0].split[-1].chop[1..-1]
        @options[param] = value
      else
        nil
      end
    end
    private :set
    
    def target value = nil
      set(value) || "#{File.join(@options['base_path'], @options['target'])}.exe"
    end
    
    def outfile
      "OutFile #{target}"
    end
    
    def base_path value = nil
      set(value) || @options['base_path']
    end
    
    def branding_image value = nil
      set(value) || @options['branding_image'] && "AddBrandingImage #{@options['branding_image'][:position]} #{@options['branding_image'][:width]} #{@options['branding_image'][:padding]}"
    end
    

    # Add accessor method for each callback, which takes a parameter to set and none to get.
    Callbacks.each do |attr|
      code = """
      def #{attr}(value = nil)
        value.nil? ? @options[:#{attr}] : @options[:#{attr}] = value
      end"""
      class_eval(code)
    end
    
    # Generates a string containing NSIS installer attributes.
    # These are generally positioned at the beginning of an NSIS script.
    def output_attributes
      [outfile, branding_image].join("\n")
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
          filename = File.basename(@options['branding_image'][:source])
          if win32
            branding_image_instructions = <<-EOS
              SetOutPath "$TEMP"
              SetFileAttributes #{filename} temporary
              File "#{@options['branding_image'][:source]}"
              SetBrandingImage "$TEMP\\#{filename}"
            EOS
          end
          
          <<-EOS
            Function .onGUIInit
              #{branding_image_instructions}
              #--------------------- begin custom code
              #{gui_init}
              #--------------------- end custom code
            FunctionEnd
          EOS
          
      end
      o.join("\n")
    end
    
    def self.win32
      RUBY_PLATFORM =~ /mswin|mingw/
    end
        
  end
end