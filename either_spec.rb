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

    describe 'left' do
      it 'returns the wrapped value' do
        expect(either_left.left).to eq :my_left
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

    describe 'right' do
      it 'returns the wrapped value' do
        expect(either_right.right).to eq :my_right
      end
    end
  end
end
