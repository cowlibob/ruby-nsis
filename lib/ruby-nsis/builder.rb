Dir.glob(File.expand_path('../*_instructions.rb', __FILE__)).each {|rb| require rb}

module NSIS
  class Builder
    attr :configuration
    
    @@scripts = []

    def self.script &block
      @@scripts << Script.new
      @@scripts.last.instance_eval(&block)
      @@scripts.last
    end
  
    def self.config(&block)
      @@configuration ||= Configuration.new
      @@configuration.instance_eval(&block)
      @@configuration
    end
  end
  
  class Script
    include NSIS::BasicInstructions
  
    def initialize
      @commands = []
    end
  
    def output
      @commands.join("\n")
    end
  end

  class Configuration
    def initialize
      @options = {}
    end
    
    # Add accessor method for each property, which takes a parameter to set and none to get.
    [:base_path].each do |attr|
      code = """
      def #{attr}(value = nil)
        value.nil? ? @options[:#{attr}] : @options[:#{attr}] = value
      end"""
      class_eval(code)
    end  

    def options
      @options
    end
  end
end