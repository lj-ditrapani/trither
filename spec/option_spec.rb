require 'spec_helper'

describe Option do
  let(:none) { Option.make(nil) }
  let(:some) { Option.make(:data) }

  describe '.make' do
    it 'returns None if passed nil' do
      expect(none).to be Option::None
    end

    it 'returns Some(value) if passed non-nil' do
      expect(some.class).to be Option::Some
      expect(some.fetch('')).to eq :data
    end
  end

  describe '.all' do
    it 'returns Some[Array] if all elements are Some' do
      result = Option.all [Option.make(:a), Option.make(:b), Option.make(:c)]
      expect(result).to eq Option::Some.new([:a, :b, :c])
    end

    it 'returns None if any element is a None' do
      result = Option.all [Option.make(:a), Option::None, Option.make(:c)]
      expect(result).to eq Option::None
    end
  end

  describe '.flatten' do
    it 'returns an array of values, filtering out the Nones' do
      result = Option.flatten [Option.make(:a), Option::None, Option.make(:c)]
      expect(result).to eq [:a, :c]
    end
  end

  describe Option::None do
    describe '.empty?' do
      it 'returns true' do
        expect(none.empty?).to be true
      end
    end

    describe '.filter' do
      it 'returns self' do
        expect(none.filter { |_x| true }).to be none
      end

      it 'does not execute given block' do
        expect do
          none.filter { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '.fetch' do
      it 'returns default' do
        expect(none.fetch('')).to eq ''
      end
    end

    describe '.map' do
      it 'returns self' do
        expect(none.map(&:-@)).to be none
      end

      it 'does not execute given block' do
        expect do
          none.map { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '.flat_map' do
      it 'returns self' do
        expect(none.flat_map(&:-@)).to be none
      end

      it 'does not execute given block' do
        expect do
          none.flat_map { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '.or_else' do
      it 'executes the given block' do
        expect do
          none.or_else { raise 'should run' }
        end.to raise_error('should run')
      end

      it 'returns value of given block' do
        option = none.or_else { Option.make :else_data }
        expect(option).to eq Option::Some.new(:else_data)
      end
    end

    describe '.get_or_else' do
      it 'executes the given block' do
        expect do
          none.get_or_else { raise 'should run' }
        end.to raise_error('should run')
      end

      it 'returns value of given block' do
        expect(none.get_or_else { :else_data }).to eq :else_data
      end
    end
  end

  describe Option::Some do
    describe '#empty?' do
      it 'returns false' do
        expect(some.empty?).to be false
      end
    end

    describe '#filter' do
      context 'the predicate returns true' do
        it 'returns self' do
          option = some.filter { |data| data == :data }
          expect(option).to eq some
        end
      end

      context 'the predicate returns false' do
        it 'returns None' do
          option = some.filter { |data| data != :data }
          expect(option).to eq none
        end
      end
    end

    describe '#fetch' do
      it 'returns value, ignoring default' do
        expect(some.fetch('')).to eq :data
      end
    end

    describe '#map' do
      context 'block returns a nil' do
        it 'returns None' do
          option = some.map { |_data| nil }
          expect(option).to eq Option::None
        end
      end

      context 'block returns a non-nil' do
        it 'executes given block with value and wraps result in a Some' do
          expect(some.map(&:to_s)).to eq Option::Some.new('data')
        end
      end
    end

    describe '#flat_map' do
      it 'executes the given block' do
        expect do
          some.flat_map { raise 'should run' }
        end.to raise_error('should run')
      end

      it 'passes the value to the block' do
        some.flat_map do |data|
          expect(data).to eq :data
          Option.make(:new_data)
        end
      end

      context 'when the block returns None' do
        it 'returns None' do
          option = some.flat_map { |_data| Option::None }
          expect(option).to be Option::None
        end
      end

      context 'when the block returns a Some' do
        it "returns the block's result" do
          option = some.flat_map { |data| Option::Some.new data.to_s }
          expect(option).to eq Option::Some.new('data')
        end
      end

      context 'when the block returns a nil' do
        it 'returns None' do
          option = some.flat_map { |_data| nil }
          expect(option).to be Option::None
        end
      end
    end

    describe '#or_else' do
      it 'returns self' do
        expect(some.or_else { Some.new(:default_data) }).to be some
      end

      it 'does not execute given block' do
        expect do
          some.or_else { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '#get_or_else' do
      it 'returns value' do
        expect(some.get_or_else { :default_data }).to eq :data
      end

      it 'does not execute block' do
        expect do
          some.get_or_else { raise 'should not run' }
        end.not_to raise_error
      end
    end
  end
end
