require 'spec_helper'

describe Trither::Matcher do
  class MyADT
  end

  describe '.new' do
    it 'takes an array of sub types (class references)' do
      C =
        class << Object.new
          self
        end
      Trither::Matcher.new(MyADT, [Symbol, String, C])
    end
  end

  describe '#on' do
    it 'adds the class & block to the @blocks hash' do
      Trither::Matcher.new(MyADT, [Symbol, String]).on Symbol do
      end
    end

    it 'fails if the class is not a member of the ADT' do
      expect do
        Trither::Matcher.new(MyADT, [Symbol, String]).on Hash do
        end
      end.to raise_error RuntimeError
    end

    it 'fails if the same class was previously defined' do
      matcher = Trither::Matcher.new(MyADT, [Symbol, String])
      matcher.on Symbol do
      end
      expect do
        matcher.on Symbol do
        end
      end.to raise_error RuntimeError
    end
  end

  describe '#exhaustive?' do
    it 'returns false if no calls to on' do
      matcher = Trither::Matcher.new(MyADT, [Symbol, String])
      expect(matcher.exhaustive?).to be false
    end

    it 'returns false if not all classes have been covered' do
      matcher = Trither::Matcher.new(MyADT, [Symbol, String])
      matcher.on Symbol do
      end
      expect(matcher.exhaustive?).to be false
    end

    it 'returns false if not all classes have been covered' do
      matcher = Trither::Matcher.new(MyADT, [Symbol, String])
      matcher.on Symbol do
      end
      matcher.on String do
      end
      expect(matcher.exhaustive?).to be true
    end
  end

  describe '#selected_block' do
    it 'returns the block that matches the class' do
      matcher = Trither::Matcher.new(MyADT, [Symbol, String])
      expected_block = ->(x) { x.to_s }
      matcher.on Symbol do
      end
      matcher.on String, &expected_block
      # Call method to un-decorate the contract-decorated block
      expect(matcher.selected_block(String).method).to be expected_block
    end
  end
end
