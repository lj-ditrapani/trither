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
      unless @expected_subtypes.include? klass
        raise "#{klass} not member of ADT #{@adt}"
      end
      raise "#{klass} matched on more than once" if @blocks.key?(klass)
      @blocks[klass] = block
      @count += 1
      @exhaustive = true if @count == @max
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
