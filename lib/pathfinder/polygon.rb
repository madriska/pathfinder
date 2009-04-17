# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  
  class Polygon
    
    def self.generate_random(options)
      options = {:max_sides => 6, :divergence => options[:width] / 4.0}.
        merge(options)

      sides = rand(options[:max_sides] - 2) + 3
      center = Point.random(options[:width], options[:height])
      new(1.upto(sides).map do
        p = center.random_divergence(options[:divergence], 
                                     options[:divergence]).
                   clamp(options[:width], options[:height])
      end)
    end

    def initialize(vertices)
      @vertices = vertices
    end

    def segments
      @vertices.each_cons(2).map{|(a,b)| LineSegment.new(a, b)} +
        [LineSegment.new(@vertices.last, @vertices.first)]
    end
    # TODO: memoize lots of things

    # Returns the first segment intersecting a segment going in segment
    # order (from +segment.first+ to +segment.second+ -- order matters).
    # TODO: This is the same logic as Path#next_obstacle.
    # Can we condense them?
    def first_intersecting_segment(segment)
      segments.sort_by do |o|
        intersection = o.intersection_pt(segment)
        case intersection
        when true then 0
        when false then 1.0/0
        else segment.first.distance(intersection)
        end
      end.first
    end

    def intersection_pt(line_segment)
      first_intersecting_segment(line_segment).intersection_pt(line_segment)
    end

    def intersects?(line_segment)
      segments.any?{|s| s.intersects?(line_segment)}
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

