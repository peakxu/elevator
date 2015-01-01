# encoding: utf-8
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
FIXTURES_PATH = File.join(File.dirname(__FILE__), 'fixtures')

require 'pry'
require 'rspec'

# Load rspec support files
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

def fixture_each_line(fixture_name)
  fixture_file = File.join(FIXTURES_PATH, fixture_name)
  File.readlines(fixture_file).each do |line|
    yield line if block_given?
  end
end
