require_glob 'instructions/*_instructions.rb'

module NSIS
  class Script
    include NSIS::BasicInstructions
    attr_reader :input_lines, :output_lines
    
    def initialize
      @output_lines = []
      @input_lines = []
    end
  
    def output
      @output_lines.join("\n")
    end
    
    def append_instruction instruction, depth = 1
      instruction = instruction.join(" ") if instruction.kind_of?(Array)
      @output_lines << instruction
      @input_lines << caller[depth].split(':').first(2).join(':')
    end
  end
end
