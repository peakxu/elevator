# encoding: utf-8
require 'spec_helper'
require 'elevator_state'

describe ElevatorState do
  let(:time) { 1 }
  subject { described_class.new(time) }

  describe '#add_elevator' do
    let(:elevator_id) { 'A' }

    it 'raises error if floor is negative' do
      expect { subject.add_elevator(elevator_id, -1) }.to \
        raise_error(ArgumentError)
    end

    it 'raises error if floor is zero' do
      expect { subject.add_elevator(elevator_id, 0) }.to \
        raise_error(ArgumentError)
    end

    it 'adds successfully if floor is positive' do
      expect { subject.add_elevator(elevator_id, 1) }.to_not raise_error
    end
  end

  context 'given a few elevators added' do
    before do
      subject.add_elevator('A', 3)
      subject.add_elevator('B', 2)
      subject.add_elevator('C', 3)
      subject.add_elevator('D', 4)
    end

    describe '#reachable_from' do
      it 'raises error if elevator_id is not found' do
        expect { subject.reachable_from('E') }.to raise_error(KeyError)
      end

      it 'returns just the elevator itself if no others are reachable' do
        expect(subject.reachable_from('B')).to eq ['B']
        expect(subject.reachable_from('D')).to eq ['D']
      end

      it 'returns also the other elevators if they are reachable' do
        expect(subject.reachable_from('A')).to eq %w(A C)
        expect(subject.reachable_from('C')).to eq %w(A C)
      end
    end
  end
end
