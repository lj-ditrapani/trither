module Try
  class Base
    def initialize(value)
      @value = value
    end
  end

  class Failure < Base
    def failure?
      true
    end

    def then
      self
    end

    def on_success
      self
    end

    def fail_map
      Failure.new(yield @value)
    end

    def on_failure
      Result.new(yield @value)
    end
  end

  class Success < Base
    def failure?
      false
    end

    def then
      yield @value
    end

    def on_success
      Success.new(yield @value)
    end

    def fail_map
      self
    end

    def on_failure
      Result.new @value
    end
  end

  class Result < Base
    def unwrap
      @value
    end
  end
end
