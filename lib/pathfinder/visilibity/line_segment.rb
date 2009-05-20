# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class LineSegment < VisiLibity::LineSegment

    def intersects?(other)
      VisiLibity.intersect(self, other, Epsilon)
    end

    # Return Pathfinder::Point objects, not VisiLibity::Point
    def first
      p = super
      Point.new(p.x, p.y)
    end

    def second
      p = super
      Point.new(p.x, p.y)
    end

  end
end


