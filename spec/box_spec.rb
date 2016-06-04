require 'spec_helper'

describe Trither::Box do
  describe '==' do
    let(:box) { Trither::Box.new(:my_data) }

    it 'returns true if both values are equal' do
      expect(box == Trither::Box.new(:my_data)).to be true
    end

    it 'returns false if lhs is not the same type' do
      expect(box == :my_data).to be false
    end

    it 'returns false if the values are not equal' do
      expect(box == Trither::Box.new(:other)).to be false
    end
  end
end
