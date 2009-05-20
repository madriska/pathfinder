# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'pathfinder/memoize'
require 'enumerator'

module Pathfinder
  class Polygon < VisiLibity::Polygon

    # Return Pathfinder::Point objects, not VisiLibity::Point
    def vertices
      super.map{|v| Point.new(v.x, v.y) }
    end

  end
end


