# encoding: utf-8

class NoSolutionError < RuntimeError; end

# This plans an elevator trip based upon elevator states
# This is a classic dynamic programming problem. We look at destination time
# and then go backwards to starting time and see if we can have a trip that
# starts at a given elevator.
class ElevatorTripPlanner
  def initialize(elevator_states, dest_floor, dest_time)
    @elevator_states = elevator_states
    @time = dest_time
    initialize_possibilities(dest_floor)
  end

  def start_from(starting)
    solution.fetch(starting)
  rescue KeyError
    raise NoSolutionError, 'no solution possible'
  end

  private

  def initialize_possibilities(dest_floor)
    @possibilities = elevator_state.elevators_at(dest_floor).map do |id|
      [id, [id]]
    end
  end

  def elevator_state
    @elevator_states.fetch(@time - 1)
  rescue IndexError
    raise ArgumentError, "No elevator information available for time #{@time}"
  end

  def solution
    return @solution if @solution
    solve_iteration while can_proceed?
    fail NoSolutionError, 'no solution possible' if @time > 1
    @solution = Hash[@possibilities.group_by { |id, _| id }.map do |id, paths|
      [id, paths.map { |_, path| path.join('') }]
    end]
  end

  def solve_iteration
    @time -= 1
    new_possibilities = @possibilities.flat_map do |id, path|
      elevator_state.reachable_from(id).map do |new_id|
        [new_id, [new_id] + path]
      end
    end
    @possibilities = new_possibilities
  end

  def can_proceed?
    !@possibilities.empty? && @time > 1
  end
end
