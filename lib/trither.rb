require 'trither/version'

module Trither
  class Box
    def initialize(value)
      @value = value
    end

    def ==(other)
      (self.class == other.class) &&
        (@value == other.instance_variable_get('@value'))
    end
  end
end

require 'trither/try'
require 'trither/either'
require 'trither/option'
