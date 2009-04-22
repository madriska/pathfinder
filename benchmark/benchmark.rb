# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

$: << 'lib'
require 'rubygems'
require 'yaml'
require 'benchmark'
require 'profiler'
require 'pathfinder'
include Pathfinder

# yeah, optparse, whatever
@profile = (ARGV == %w[-p])

maps = YAML.load_file(File.join(%w[benchmark benchmark_data.yml]))
successful = 0

Profiler__::start_profile if @profile

time = Benchmark.measure do
  maps.each do |map|
    path = Path.new(Point.new(0,0), Point.new(100,100), map)
    path = path.shortest_path
    successful += 1 if path && path.complete?
  end
end

if @profile
  result = Profiler__::stop_profile
  File.open('profile_results.txt', 'w') do |file|
    Profiler__::print_profile(file)
  end
  puts "Profiling output written to profile_results.txt"
end

puts "Completed #{successful} paths"
puts "Time: #{time}"

