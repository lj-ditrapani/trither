module Trither
  class Matcher
    include Contracts::Core
    include BasicTypes

    Contract Class, C::ArrayOf[Class] => C::Any
    def initialize(adt, expected_subtypes)
      @adt = adt
      @expected_subtypes = expected_subtypes
      @blocks = {}
      @max = expected_subtypes.size
      @exhaustive = false
      @count = 0
    end

    Contract Class, C::Func[C::Any => C::Any] => nil
    def on(klass, &block)
      if @expected_subtypes.include? klass
        if @blocks.key?(klass)
          raise RuntimeError.new("#{klass} matched on more than once")
        else
          @blocks[klass] = block
          @count += 1
          if @count == @max
            @exhaustive = true
          end
        end
      else
        raise RuntimeError.new("#{klass} not member of ADT #{@adt}")
      end
      nil
    end

    Contract C::None => C::Bool
    def exhaustive?
      @exhaustive
    end

    Contract Class => C::Func[C::Any => C::Any]
    def selected_block(klass)
      @blocks[klass]
    end
  end
end
