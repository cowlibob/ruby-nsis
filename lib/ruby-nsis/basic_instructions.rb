module NSIS
  module BasicInstructions
    
    # Adds file(s) to be extracted to the current output path
    # 
    # - Use <code>:as => 'new_name'</code> to specify an output name distinct from the input name.
    #   <code>new_name</code> may contain variables and can be a fully qualified path or relative
    #   path, in which case it will be appended to the current output directory. Using this option,
    #   only one source file can be specified
    
    def file filename, options = {}
      source = File.join(Builder.config.base_path, filename)
      if options[:as] and Dir.glob(source).length > 1
        raise NSIS::BadParameterError.new("NSIS::Script::file() may only accept a single source if :as is specified.")
      end
      
      command = ["File"]
      
      # non-fatal, if no match is found, a warning rather than error will be issued.
      command << "/nonfatal" if options[:nonfatal]
      
      # recursive
      command << "/r" if options[:recurse]

      # excluded files
      command << [options[:not]].flatten.collect{|n| "/x #{n}"}.join(' ') if options[:not]
      
      # rename or straight
      command << (options[:as] ? "/oname=\"#{options[:as]}\" #{filename}" : filename)
      
      @commands << command.join(" ")
    end
    
    
    def rename source, dest, options = {}
      command = ["Rename"]
      
      command << "/REBOOTOK" if options[:allow_reboot]
      
      command << source << dest
      
      @commands << command.join(" ")
    end
  end
end