# encoding: utf-8
require 'spec_helper'
require 'elevator_state_reader'

describe ElevatorStateReader do
  subject { described_class.new }

  before do
    fixture_each_line('multiple_elevator_states.txt') do |line|
      subject.parse_line(line)
    end
    subject.parse_line('')  # Send final empty line through
  end

  describe '#elevator_states' do
    let(:elevator_states) { subject.elevator_states }

    it 'returns 3 elevator states' do
      expect(elevator_states.size).to eq 3
    end

    it 'returns expected first elevator state' do
      state_1 = elevator_states[0]
      expect(state_1.time).to eq 1
      expect(state_1.elevators_at(1)).to eq %w(A D)
      expect(state_1.elevators_at(2)).to eq ['C']
      expect(state_1.elevators_at(3)).to eq ['B']
    end

    it 'returns expected second elevator state' do
      state_2 = elevator_states[1]
      expect(state_2.time).to eq 2
      expect(state_2.elevators_at(1)).to eq %w(C D)
      expect(state_2.elevators_at(2)).to eq ['A']
      expect(state_2.elevators_at(4)).to eq ['B']
    end

    it 'returns expected third elevator state' do
      state_3 = elevator_states[2]
      expect(state_3.time).to eq 3
      expect(state_3.elevators_at(2)).to eq ['C']
      expect(state_3.elevators_at(3)).to eq ['B']
      expect(state_3.elevators_at(4)).to eq ['D']
      expect(state_3.elevators_at(5)).to eq ['A']
    end
  end
end
