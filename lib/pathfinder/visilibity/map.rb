# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Map < VisiLibity::Environment

    def initialize(width, height, obstacles)
      boundary = VisiLibity::Polygon.new([VisiLibity::Point.new(0,0),
                                         VisiLibity::Point.new(width,0),
                                         VisiLibity::Point.new(width,height),
                                         VisiLibity::Point.new(0,height)])
      super([boundary] + obstacles)
    end

  end
end


