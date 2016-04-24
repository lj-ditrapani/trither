describe Try do
  let(:try_failure) { Try::Failure.new :my_error }
  let(:try_success) { Try::Success.new :my_data }

  describe Try::Failure do
    describe '#failure?' do
      it 'returns true' do
        expect(try_failure.failure?).to eq(true)
      end
    end

    describe '#then' do
      it 'returns self' do
        new_try = try_failure.then do
          try_success
        end
        expect(new_try).to eq try_failure
      end

      it 'does not execute the try_block' do
        expect do
          try_failure.then do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end

    describe '#on_success' do
      it 'returns self' do
        new_try = try_failure.on_success do
          :my_data
        end
        expect(new_try).to eq try_failure
      end

      it 'does not execute the try_block' do
        expect do
          try_failure.on_success do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end

    describe '#fail_map' do
      it 'executes given block with error value and wraps result in a Failure' do
        try = try_failure.fail_map(&:to_s)
        expect(try.on_failure { |e| e }.unwrap).to eq 'my_error'
      end
    end

    describe '#on_failure' do
      it "executes given block with error value and returns block's result" do
        error = try_failure.on_failure(&:to_s).unwrap
        expect(error).to eq 'my_error'
      end
    end
  end

  describe Try::Success do
    describe '#failure?' do
      it 'returns false' do
        expect(try_success.failure?).to eq(false)
      end
    end

    describe '#then' do
      it 'executes the given block' do
        expect do
          try_success.then do
            raise 'should run'
          end
        end.to raise_error('should run')
      end

      context 'when the block returns an Error' do
        it "pass value to block & returns the block's result" do
          try = try_success.then do |data|
            Try::Failure.new "bad #{data}"
          end
          expect(try.failure?).to eq true
          expect(try.on_failure { |e| e }.unwrap).to eq 'bad my_data'
        end
      end

      context 'when the block returns a Data' do
        it "pass value to block & returns the block's result" do
          try = try_success.then do |data|
            Try::Success.new data.to_s
          end
          expect(try.failure?).to eq false
          expect(try.on_failure { :no_op }.unwrap).to eq 'my_data'
        end
      end
    end

    describe '#on_success' do
      it 'executes given block with data value and wraps result in a Success' do
        try = try_success.on_success(&:to_s)
        expect(try.on_failure { :no_op }.unwrap).to eq 'my_data'
      end
    end

    describe '#fail_map' do
      it 'returns self' do
        new_try = try_success.fail_map do
          :my_error
        end
        expect(new_try).to eq try_success
      end

      it 'does not execute the try_block' do
        expect do
          try_success.fail_map do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end

    describe '#on_failure' do
      it 'returns the data value' do
        expect(try_success.on_failure { :no_op }.unwrap).to eq :my_data
      end

      it 'does not execute the try_block' do
        expect do
          try_success.on_failure do
            raise 'should not run'
          end
        end.not_to raise_error
      end
    end
  end
end
