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
      @@configuration.instance_eval(&block) if block_given?
      @@configuration
    end
  end
  
  class Script
    include NSIS::BasicInstructions
    attr_reader :sources, :commands
    
    def initialize
      @commands = []
      @sources = []
    end
  
    def output
      @commands.join("\n")
    end
    
    def append_instruction instruction, depth = 1
      instruction = instruction.join(" ") if instruction.kind_of?(Array)
      @commands << instruction
      @sources << caller[depth].match(/(.*:.*)[:]/)[1]
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