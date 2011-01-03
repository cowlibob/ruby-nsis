module NSIS
  module MacroInstructions
    def if_defined? symbol, &block
      block_begin "!ifdef #{symbol}"
      block.yield
      block_end "!endif\n"
    end
    
    def if_not_defined? symbol, &block
      block_begin "!ifndef #{symbol}"
      block.yield
      block_end "!endif\n"
    end
    
    def include source
      append_instruction "!include '#{source}'"
    end
  end
end