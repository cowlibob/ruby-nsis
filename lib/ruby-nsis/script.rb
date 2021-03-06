# encoding: utf-8

require_glob 'instructions/*_instructions.rb'
require 'tempfile'

module NSIS
  class Script
    include NSIS::BasicInstructions
    include NSIS::MacroInstructions
    
    attr_reader :input_lines, :output_lines, :build_report
    
    def initialize config = nil
      @config = config || Builder.config{}
      @output_lines = []
      @input_lines = []
      @tab_depth = 0
    end
    
    def output
      @output_lines.join("\n")
    end
    
    def append_instruction instruction, depth = 1
      instruction = instruction.join(" ") if instruction.kind_of?(Array)
      @output_lines << ("  " * @tab_depth) + instruction
      @input_lines << caller[depth].split(':').first(2).join(':')
    end
    
    def block_begin instruction
      append_instruction instruction
      @tab_depth += 1
    end
    
    def block_end instruction
      @tab_depth -= 1
      append_instruction instruction    end
      
    
    def build
      Tempfile.open('ruby-nsis') do |out|
        out << "##{caller}\n#-------------\n"
        out << @config.output_attributes
        out << "\n"
        out << output
        out.close
        
        #`mate #{out.path}`
        options = []
        #options << "-XOutFile #{@config.target}" unless output.match /OutFile/
        cmd = %Q[./bin/makensis #{options.join(' ')} #{out.path}]
        @build_report = %x[#{cmd}]
      end
    end
    
    def clean
      File.delete @config.target if File.exist? @config.target
    end
  end
end
