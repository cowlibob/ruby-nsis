module NSIS
  module BasicInstructions
    
    # Echos input to output. Useful for NSIS instructions/features not implemented specifically in ruby-nsis.
    
    def echo *input
      append_instruction input.join(' ')
    end
    
    # Adds file(s) to be extracted to the current output path
    # 
    # - Use <code>:as => 'new_name'</code> to specify an output name distinct from the input name.
    #   <code>new_name</code> may contain variables and can be a fully qualified path or relative
    #   path, in which case it will be appended to the current output directory. Using this option,
    #   only one source file can be specified
    
    def file filename, options = {}
      if options[:as] and Dir.glob(File.join(Builder.config.base_path, filename)).length > 1
        raise NSIS::BadParameterError.new("NSIS::Script::file() may only accept a single source if :as is specified.")
      end
      
      command = ["File"]
      
      # non-fatal, if no match is found, a warning rather than error will be issued.
      command << "/nonfatal" if options[:nonfatal]
      
      # recursive
      command << "/r" if options[:recurse]
      
      # preserve attributes
      command << "/a" if options[:with_attributes]

      # excluded files
      command << [options[:not]].flatten.collect{|n| "/x #{n}"}.join(' ') if options[:not]
      
      # rename or straight
      command << (options[:as] ? "/oname=\"#{options[:as]}\" #{filename}" : filename)
      
      append_instruction command
    end
    
    # Renames files already on target system
    #
    # - Use <code>:allow_reboot => true</code> to enable rename after a reboot, useful for DLLs in use etc.
    #
    def rename source, dest, options = {}
      command = ["Rename"]
      
      command << "/REBOOTOK" if options[:allow_reboot]
      
      command << source << dest
      
      append_instruction command
      
    end
  end
end