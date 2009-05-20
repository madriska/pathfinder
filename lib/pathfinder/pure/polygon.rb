# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  
  class Polygon
    
    attr_reader :vertices
    def initialize(vertices)
      @vertices = vertices
    end

    Infinity = 1.0/0

    # Returns the first segment intersecting a segment going in segment
    # order (from +segment.first+ to +segment.second+ -- order matters).
    # TODO: This is the same logic as Path#next_obstacle.
    # Can we condense them?
    def first_intersecting_segment(segment)
      segments.sort_by do |o|
        intersection = o.intersection_pt(segment)
        intersection ? segment.first.distance(intersection) : Infinity
      end.first
    end

    def intersection_pt(line_segment)
      first_intersecting_segment(line_segment).intersection_pt(line_segment)
    end

    # On a ray going from +line_segment.first+ towards +line_segment.second+,
    # returns points should we use when trying to get around this obstacle.
    #
    # TODO: Think about how to do more local processing here, rather than 
    # deferring the fixup to the backtracker. We can't just reject points
    # inside the polygon; we have to actually chase line segments around the
    # polygon.
    def ways_around(line_segment)
      seg = first_intersecting_segment(line_segment)
      [seg.off_first, seg.off_second]
    end

  end

end

