# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Path < VisiLibity::Polyline

    def initialize(start, goal, steps)
      super([start] + steps)
    end

    def steps
      vertices
    end

    

  end
end


