require 'trither/version'
require 'contracts'

module Trither
  class Box
    include Contracts::Core
    C = Contracts

    Contract C::Any => C::Any
    def initialize(value)
      @value = value
    end

    Contract C::Any => C::Bool
    def ==(other)
      (self.class == other.class) &&
        (@value == other.instance_variable_get('@value'))
    end
  end
end

require 'trither/try'
require 'trither/either'
require 'trither/option'
