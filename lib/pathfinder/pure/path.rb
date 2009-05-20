# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'pathfinder/memoize'
require 'priority_set'

module Pathfinder
  # Represents a start and end point and a (potentially partial) path
  # from the start point toward the end point.
  class Path
    
    attr_reader :steps, :goal
    def initialize(start, goal, steps=[])
      @steps = [start] + steps
      @goal  = goal
    end

    def inspect
      "(Path goal=#{goal.inspect} steps=(#{steps.map{|s| s.inspect}.join(' ')}))"
    end

    def cost
      each_segment.inject(0){|sum, (a,b)| sum + a.distance(b)}
    end

  end
end
