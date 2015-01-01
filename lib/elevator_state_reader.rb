# encoding: utf-8

require 'elevator_state'

# This class is in charge of processing one line of input at a time and
# processing it into a series of elevator state objects
#
# Design decisions:
# 1. This class will not handle file I/O or std I/O. That's for the imperative
#    shell to perform
# 2. This class will not enforce strict invariants. For instance, we will allow
#    multiple elevators per shaft. We will also not enforce temporal continuity
#    across elevator states (elevators may exist in t1 and t3, but not in t2,
#    chalk up to missing sample, etc.) We do this in the interests of limiting
#    system complexity given no direct requirement for these.
# 3. We do enforce that we only see a single copy of an elevator in any given
#    state. Highlander rules.
class ElevatorStateReader
  VALID_ELEVATOR_IDS = /[A-Z]/

  attr_reader :elevator_states

  def initialize
    @time = 0
    @elevator_states = []
    reset_elevators
  end

  def parse_line(line)
    sanitized_line = line.strip
    if sanitized_line.empty?
      serialize_elevator_state
      reset_elevators
    else
      increment_all_existing_elevators
      sanitized_line.scan(VALID_ELEVATOR_IDS).each { |id| add_new_elevator(id) }
    end
  end

  private

  def increment_all_existing_elevators
    @elevators.keys.each { |id| @elevators[id] += 1 }
  end

  def add_new_elevator(id)
    if @elevators[id]
      fail ArgumentError, "duplicate elevator with id #{id} at time #{time}"
    else
      @elevators[id] = 1
    end
  end

  def serialize_elevator_state
    return if @elevators.empty?
    @time += 1
    elevator_state = ElevatorState.new(@time)
    @elevators.each { |id, floor| elevator_state.add_elevator(id, floor) }
    @elevator_states << elevator_state
  end

  def reset_elevators
    @elevators = {}  # id => floor
  end
end
