# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Path < VisiLibity::Polyline

    attr_reader :goal # used in pdf.rb

    def initialize(start, goal, steps)
      @goal = goal
      super([start] + steps)
    end

    def steps
      vertices.map{|p| Point.new(p.x, p.y)}
    end

    

  end
end


