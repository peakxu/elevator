# encoding: utf-8
require 'spec_helper'
require 'elevator_state_reader'
require 'elevator_trip_planner'

describe ElevatorTripPlanner do
  let(:elevator_states) do
    state_reader = ElevatorStateReader.new
    fixture_each_line('multiple_elevator_states.txt') do |line|
      state_reader.parse_line(line)
    end
    state_reader.parse_line('')  # Send final empty line through
    state_reader.elevator_states
  end

  describe '#start_from' do
    subject { described_class.new(elevator_states, 4, 3) }

    it 'returns all expected solutions' do
      expect(subject.start_from('C')).to eq ['CCD']
    end

    it 'returns all expected solutions' do
      expect(subject.start_from('A')).to eq ['ADD']
    end

    it 'raises error if no solution exists' do
      expect { subject.start_from('B') }.to raise_error(NoSolutionError)
    end
  end
end
