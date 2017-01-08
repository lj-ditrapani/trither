require 'contracts'

module Option
  include Contracts::Core
  C = Contracts

  module None
  end

  class Some < Trither::Box
  end

  NoneType = ->(x) { x == None }
  OptionType = C::Or[NoneType, Some]
  Func1toOption = C::Func[C::Any => OptionType]

  Contract C::Any => C::Or[->(x) { x == None }, Some]
  def self.make(value)
    if value.nil?
      None
    else
      Some.new(value)
    end
  end

  Contract C::ArrayOf[OptionType] => OptionType
  def self.all(array_of_options)
    array_of_options.reduce(Some.new([])) do |memo, option|
      memo.flat_map do |array|
        option.map { |value| array + [value] }
      end
    end
  end

  Contract C::ArrayOf[OptionType] => C::ArrayOf[C::Any]
  def self.flatten(array_of_options)
    array_of_options.reduce([]) do |array, option|
      if option.empty?
        array
      else
        array + [option.get_or_else { raise StandardError }]
      end
    end
  end

  module None
    include Contracts::Core
    include ::Trither::BasicTypes

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

    Contract Func1 => NoneType
    def self.map
      self
    end

    Contract Func1toOption => OptionType
    def self.flat_map
      self
    end

    Contract Func1toOption => OptionType
    def self.or_else
      yield
    end

    Contract Func0 => C::Any
    def self.get_or_else
      yield
    end
  end

  class Some
    include ::Trither::BasicTypes

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

    Contract Func1 => OptionType
    def map
      Option.make(yield @value)
    end

    Contract Func1toOption => OptionType
    def flat_map
      result = yield @value
      if result.nil?
        None
      else
        result
      end
    end

    Contract Func1toOption => Some
    def or_else
      self
    end

    Contract Func0 => C::Any
    def get_or_else
      @value
    end
  end
end
