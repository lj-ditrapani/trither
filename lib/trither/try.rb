module Try
  def self.make
    Success.new(yield)
  rescue StandardError => error
    Failure.new(error)
  end

  class Base
    def initialize(value)
      @value = value
    end
  end

  class Failure < Base
    def failure?
      true
    end

    def flat_map
      self
    end

    def map
      self
    end

    def fail_map
      Failure.new(yield @value)
    end

    def get_or_else
      yield @value
    end
  end

  class Success < Base
    def failure?
      false
    end

    def flat_map
      yield @value
    end

    def map
      Success.new(yield @value)
    end

    def fail_map
      self
    end

    def get_or_else
      @value
    end
  end
end
