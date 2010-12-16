module NSIS
  class Script
    def initialize
      @commands = []
    end
    
    def file filename, options = {}
      command = ["File"]
      
      # excluded files
      command << [options[:not]].flatten.collect{|n| "/x #{n}"}.join(' ') if options[:not]
      
      # rename or straight
      command << (options[:as] ? "/oname=#{options[:as]} #{filename}" : filename)
      
      @commands << command.join(" ")
    end
    
    def output
      @commands.join("\n")
    end
  end
  
  def self.script &block
    s = Script.new
    s.instance_eval(&block)
    s
  end
end