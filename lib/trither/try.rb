require 'contracts'

module Try
  include Contracts::Core
  include ::Trither::BasicTypes

  class Failure < Trither::Box
  end

  class Success < Trither::Box
  end

  TryType = C::Or[Failure, Success]
  Func0toTry = C::Func[C::None => TryType]
  Func1toTry = C::Func[C::Any => TryType]

  Contract Func1 => TryType
  def self.make
    Success.new(yield)
  rescue StandardError => error
    Failure.new(error)
  end

  class Failure < Trither::Box
    include ::Trither::BasicTypes

    Contract C::None => true
    def failure?
      true
    end

    Contract Predicate => Failure
    def filter
      self
    end

    Contract Func1toTry => Failure
    def flat_map
      self
    end

    Contract Func1 => Failure
    def map
      self
    end

    Contract Func1 => Failure
    def fail_map
      Failure.new yield(@value)
    end

    Contract Func0toTry => TryType
    def or_else
      yield @value
    end

    Contract Func0 => C::Any
    def get_or_else
      yield @value
    end
  end

  class Success < Trither::Box
    include ::Trither::BasicTypes

    Contract C::None => false
    def failure?
      false
    end

    Contract Predicate => TryType
    def filter
      yield(@value) ? self : Failure.new(Option::None)
    end

    Contract Func1toTry => TryType
    def flat_map
      yield @value
    end

    Contract Func1 => TryType
    def map
      Success.new yield(@value)
    end

    Contract Func1 => TryType
    def fail_map
      self
    end

    Contract Func0toTry => TryType
    def or_else
      self
    end

    Contract Func0 => C::Any
    def get_or_else
      @value
    end
  end
end
