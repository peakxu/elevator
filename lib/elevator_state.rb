# encoding: utf-8

require 'set'

# This encapsulates the state of an elevator system.
class ElevatorState
  attr_reader :time

  def initialize(time)
    @time = time
    @floor_to_elevators = {}
    @elevator_floor = {}
  end

  def add_elevator(elevator_id, floor)
    fail ArgumentError, 'floor must be positive' unless floor > 0
    @floor_to_elevators[floor] ||= Set.new
    @floor_to_elevators[floor] << elevator_id
    @elevator_floor[elevator_id] = floor
  end

  # Returns all elevators we can transfer to from given elevator
  def reachable_from(elevator_id)
    floor = @elevator_floor[elevator_id]
    fail KeyError, "cannot find elevator #{elevator_id}" unless floor

    elevators_at(floor).sort
  end

  def elevators_at(floor)
    @floor_to_elevators[floor].to_a
  end
end
