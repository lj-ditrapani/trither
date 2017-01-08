require 'contracts'

module Either
  class Left < Trither::Box
    include Contracts::Core
    C = Contracts
    Func1 = C::Func[C::Any => C::Any]

    Contract C::None => true
    def left?
      true
    end

    Contract C::None => false
    def right?
      false
    end

    Contract C::None => C::Any
    def left
      @value
    end

    Contract Func1 => Left
    def left_map
      Left.new(yield @value)
    end

    Contract Func1 => Left
    def right_map
      self
    end
  end

  class Right < Trither::Box
    include Contracts::Core
    C = Contracts
    Func1 = C::Func[C::Any => C::Any]

    Contract C::None => false
    def left?
      false
    end

    Contract C::None => true
    def right?
      true
    end

    Contract C::None => C::Any
    def right
      @value
    end

    Contract Func1 => Right
    def left_map
      self
    end

    Contract Func1 => Right
    def right_map
      Right.new(yield @value)
    end
  end
end
