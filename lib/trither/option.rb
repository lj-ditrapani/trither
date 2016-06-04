module Option
  def self.make(value)
    if value.nil?
      None
    else
      Some.new(value)
    end
  end

  module None
    def self.empty?
      true
    end

    def self.filter
      self
    end

    def self.fetch(default)
      default
    end

    def self.map
      self
    end

    def self.flat_map
      self
    end

    def self.or_else
      yield
    end

    def self.get_or_else
      yield
    end
  end

  class Some < Trither::Box
    def empty?
      false
    end

    def filter
      yield(@value) ? self : None
    end

    def fetch(_default)
      @value
    end

    def map
      Option.make(yield @value)
    end

    def flat_map
      result = yield @value
      if result.nil?
        None
      else
        result
      end
    end

    def or_else
      self
    end

    def get_or_else
      @value
    end
  end
end
