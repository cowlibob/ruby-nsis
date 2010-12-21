module NSIS
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