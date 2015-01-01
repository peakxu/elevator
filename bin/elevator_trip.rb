#!/usr/bin/env ruby
# encoding: utf-8

$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'elevator_state_reader'
require 'elevator_trip_planner'

has_args = ARGV.size == 3

fail ArgumentError, 'Must provide elevator_trip.rb <elevator system filename> '\
                    '<starting elevator> <final destination>' unless has_args

elevator_system_filename = ARGV[0]

state_reader = ElevatorStateReader.new
File.readlines(elevator_system_filename).each do |line|
  state_reader.parse_line(line)
end
state_reader.parse_line('')

final_destination = ARGV[2]

matches = final_destination.match(/(?<floor>[0-9]+)-(?<time>[0-9]+)/)

fail 'final destination must be of format <floor>-<time>' unless matches

trip_planner = ElevatorTripPlanner.new(state_reader.elevator_states,
                                       matches[:floor].to_i,
                                       matches[:time].to_i)

start_elevator = ARGV[1]

begin
  puts trip_planner.start_from(start_elevator).first  # Only print 1 solution
rescue StandardError => ex
  $stderr.puts ex
end
