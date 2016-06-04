require 'spec_helper'

describe Try do
  let(:try_failure) { Try::Failure.new :my_error }
  let(:try_success) { Try::Success.new :my_data }

  describe '.make' do
    it 'returns Success(value) if block succeeds without error' do
      expect(Try.make { :data }).to eq Try::Success.new(:data)
    end

    it 'returns Failure(error) if block raises an error' do
      try = Try.make { raise FloatDomainError, 'foo' }
      expect(try.failure?).to be true
      try.fail_map do |error|
        expect(error.class).to eq FloatDomainError
        expect(error.message).to eq 'foo'
      end
    end
  end

  describe Try::Failure do
    describe '#failure?' do
      it 'returns true' do
        expect(try_failure.failure?).to eq(true)
      end
    end

    describe '#flat_map' do
      it 'returns self' do
        new_try = try_failure.flat_map { try_success }
        expect(new_try).to eq try_failure
      end

      it 'does not execute the try_block' do
        expect do
          try_failure.flat_map { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '#map' do
      it 'returns self' do
        new_try = try_failure.map { :my_data }
        expect(new_try).to eq try_failure
      end

      it 'does not execute the try_block' do
        expect do
          try_failure.map { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '#fail_map' do
      it(
        'executes given block with error value and wraps result in a Failure'
      ) do
        try = try_failure.fail_map(&:to_s)
        expect(try).to eq Try::Failure.new('my_error')
      end
    end

    describe '#get_or_else' do
      it 'executes given block with error value and returns result' do
        error = try_failure.get_or_else(&:to_s)
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

    describe '#flat_map' do
      it 'executes the given block' do
        expect do
          try_success.flat_map { raise 'should run' }
        end.to raise_error('should run')
      end

      context 'when the block returns an Failure' do
        it "pass value to block & returns the block's result" do
          try = try_success.flat_map do |data|
            Try::Failure.new "bad #{data}"
          end
          expect(try).to eq Try::Failure.new('bad my_data')
        end
      end

      context 'when the block returns a Success' do
        it "pass value to block & returns the block's result" do
          try = try_success.flat_map do |data|
            Try::Success.new data.to_s
          end
          expect(try).to eq Try::Success.new('my_data')
        end
      end
    end

    describe '#map' do
      it 'executes given block with data value and wraps result in a Success' do
        try = try_success.map(&:to_s)
        expect(try).to eq Try::Success.new('my_data')
      end
    end

    describe '#fail_map' do
      it 'returns self' do
        expect(try_success.fail_map { :my_error }).to eq try_success
      end

      it 'does not execute the try_block' do
        expect do
          try_success.fail_map { raise 'should not run' }
        end.not_to raise_error
      end
    end

    describe '#get_or_else' do
      it 'returns the data value' do
        expect(try_success.get_or_else { :no_op }).to eq :my_data
      end

      it 'does not execute the try_block' do
        expect do
          try_success.get_or_else { raise 'should not run' }
        end.not_to raise_error
      end
    end
  end
end
