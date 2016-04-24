module Either
  class Base
    def initialize(value)
      @value = value
    end
  end

  class Left < Base
    def left?
      true
    end

    def right?
      false
    end

    def left
      @value
    end

    def left_map
      Left.new(yield @value)
    end

    def right_map
      self
    end
  end

  class Right < Base
    def left?
      false
    end

    def right?
      true
    end

    def right
      @value
    end

    def left_map
      self
    end

    def right_map
      Right.new(yield @value)
    end
  end
end
