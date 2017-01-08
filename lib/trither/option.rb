module Option
  include Contracts::Core
  C = Contracts

  module None
  end

  class Some < Trither::Box
  end

  NoneType = ->(x) { x == None }
  OptionType = C::Or[NoneType, Some]
  Predicate = C::Func[C::Any => C::Bool]

  Contract C::Any => C::Or[->(x) { x == None }, Some]
  def self.make(value)
    if value.nil?
      None
    else
      Some.new(value)
    end
  end

  module None
    include Contracts::Core

    Contract C::None => true
    def self.empty?
      true
    end

    Contract Predicate => NoneType
    def self.filter
      self
    end

    Contract C::Any => C::Any
    def self.fetch(default)
      default
    end

    Contract C::Func[C::Any => C::Any] => NoneType
    def self.map
      self
    end

    Contract C::Func[C::Any => OptionType] => OptionType
    def self.flat_map
      self
    end

    Contract C::Func[C::None => OptionType] => OptionType
    def self.or_else
      yield
    end

    Contract C::Func[C::None => C::Any] => C::Any
    def self.get_or_else
      yield
    end
  end

  class Some
    include Contracts::Core

    Contract C::None => false
    def empty?
      false
    end

    Contract Predicate => OptionType
    def filter
      yield(@value) ? self : None
    end

    Contract C::Any => C::Any
    def fetch(_default)
      @value
    end

    Contract C::Func[C::Any => C::Any] => OptionType
    def map
      Option.make(yield @value)
    end

    Contract C::Func[C::Any => OptionType] => OptionType
    def flat_map
      result = yield @value
      if result.nil?
        None
      else
        result
      end
    end

    Contract C::Func[C::None => OptionType] => Some
    def or_else
      self
    end

    Contract C::Func[C::None => C::Any] => C::Any
    def get_or_else
      @value
    end
  end
end
