# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class LineSegment < VisiLibity::LineSegment

    def intersects?(other)
      VisiLibity.intersect(self, other)
    end

  end
end


