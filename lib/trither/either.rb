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
  end
end
