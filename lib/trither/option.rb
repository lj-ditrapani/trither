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

    def self.fetch(default)
      default
    end

    def self.map
      self
    end

    def self.flat_map
      self
    end
  end

  class Some
    def initialize(value)
      @value = value
    end

    def empty?
      false
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
  end
end
