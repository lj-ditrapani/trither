require 'trither/version'
require 'contracts'

module Trither
  module BasicTypes
    C = Contracts
    Predicate = C::Func[C::Any => C::Bool]
    Func0 = C::Func[C::None => C::Any]
    Func1 = C::Func[C::Any => C::Any]
  end

  class Box
    include Contracts::Core
    include BasicTypes

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

require 'trither/matcher'
require 'trither/adt'
require 'trither/try'
require 'trither/either'
require 'trither/option'
