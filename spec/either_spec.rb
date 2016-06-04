require 'spec_helper'

describe 'Either' do
  let(:either_left) { Either::Left.new :my_left }
  let(:either_right) { Either::Right.new :my_right }

  describe Either::Left do
    describe '#left?' do
      it 'returns true' do
        expect(either_left.left?).to eq(true)
      end
    end

    describe '#right?' do
      it 'returns false' do
        expect(either_left.right?).to eq(false)
      end
    end

    describe '#left' do
      it 'returns the wrapped value' do
        expect(either_left.left).to eq :my_left
      end
    end

    describe '#left_map' do
      it 'executes given block with value and wraps result in a Left' do
        expect(either_left.left_map(&:to_s)).to eq Either::Left.new('my_left')
      end
    end

    describe '#right_map' do
      it 'returns self' do
        expect(either_left.right_map { :other }).to eq either_left
      end

      it 'does not execute given block' do
        expect do
          either_left.right_map do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end
  end

  describe Either::Right do
    describe '#left?' do
      it 'returns false' do
        expect(either_right.left?).to eq(false)
      end
    end

    describe '#right?' do
      it 'returns true' do
        expect(either_right.right?).to eq(true)
      end
    end

    describe '#right' do
      it 'returns the wrapped value' do
        expect(either_right.right).to eq :my_right
      end
    end

    describe '#left_map' do
      it 'returns self' do
        expect(either_right.left_map { :other }).to eq either_right
      end

      it 'does not execute given block' do
        expect do
          either_right.left_map do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end

    describe '#right_map' do
      it 'executes given block with value and wraps result in a Right' do
        either = either_right.right_map(&:to_s)
        expect(either).to eq(Either::Right.new('my_right'))
      end
    end
  end
end
