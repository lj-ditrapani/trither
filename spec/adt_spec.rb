require 'spec_helper'

describe ADT do
  xit 'not done yet' do
    module Maybe
      include ADT

      def common
        puts "common from #{self}"
      end
    end

    Nada = Object.new
    class << Nada
      def foo
        'foo on Nada'
      end

      def self.inspect
        'Nada Singleton Class'
      end

      def self.to_s
        inspect
      end

      def to_s
        'Nada'
      end

      def inspect
        'Nada'
      end
      include Maybe
    end

    class Just
      include Maybe

      def initialize(value)
        @value = value
      end

      def get
        @value
      end
    end

    puts "Maybe.sealed? #{Maybe.sealed?}"
    Maybe.seal
    puts "Maybe.sealed? #{Maybe.sealed?}"
    puts "ADT.@sealed #{ADT.instance_variable_get('@sealed').inspect}"
    puts "Mabye.@sealed #{Maybe.instance_variable_get('@sealed').inspect}"

    puts Nada.foo
    puts Nada.is_a? Maybe
    j = Just.new(5)
    puts j.get
    puts j.is_a? Maybe
    puts "Maybe.sub_types #{Maybe.sub_types}"

    j.match
    Nada.match

    j.common
    Nada.common
  end
end
