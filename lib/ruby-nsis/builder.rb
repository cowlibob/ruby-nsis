# encoding: utf-8

require_relative 'patches/kernel'
require_relative 'script'
require_relative 'configuration'

module NSIS
  class Builder
    attr :configuration
    
    @@scripts = []

    def self.script(config = nil, &block)
      @@scripts << Script.new(config)
      @@scripts.last.instance_eval(&block)
      @@scripts.last
    end
  
    def self.config(&block)
      @@configuration ||= Configuration.new
      @@configuration.instance_eval(&block) if block_given?
      @@configuration
    end
  end
end
