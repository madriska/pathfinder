# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  
  class LineSegment < Struct.new(:first, :second)
    def inspect
      "(LineSegment #{first.inspect} #{second.inspect})"
    end
    
    # Linear combination of the two points. project(0) == first; 
    # project(1) == second.
    def project(p)
      Point.new(first.x + p*(second.x - first.x),
                first.y + p*(second.y - first.y))
    end

    # Approximately, how close off_first and off_second are to first and second
    Epsilon = 0.1 

    # Returns a point slightly off of the "first" end of the segment.
    def off_first
      project(0.0 - (Epsilon / length))
    end

    # Returns a point slightly off of the "second" end of the segment.
    def off_second
      project(1.0 + (Epsilon / length))
    end

    def slope
      (second.y - first.y).to_f / (second.x - first.x)
    end
      
    # [[x1,y1],[x2,y2]]
    def to_a
      [first.to_a, second.to_a]	
    end

    # Translated and adapted from: 
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/example.cpp
    # Returns true for coincident line segments; false for nonintersecting
    # segments; and the point of intersection for intersecting segments.
    def intersection_pt(other) 
      denom = ((other.second.y - other.first.y).to_f*(second.x - first.x)) -
              ((other.second.x - other.first.x).to_f*(second.y - first.y))
      numea = ((other.second.x - other.first.x).to_f*(first.y - other.first.y)) -
              ((other.second.y - other.first.y).to_f*(first.x - other.first.x))
      numeb = ((second.x - first.x).to_f*(first.y - other.first.y)) -
              ((second.y - first.y).to_f*(first.x - other.first.x))

      if denom.zero?
        # TODO: special-case these?
        if numea.zero? && numeb.zero?
          return true # coincident
        else
          return false # parallel
        end
      end
      
      ua = numea / denom
      ub = numeb / denom

      if (0.0..1.0).include?(ua) && (0.0..1.0).include?(ub)
        Point.new(first.x + ua*(second.x - first.x),
                  first.y + ua*(second.y - first.y))
      else
        false
      end
    end

    alias_method :intersects?, :intersection_pt
  end

end
