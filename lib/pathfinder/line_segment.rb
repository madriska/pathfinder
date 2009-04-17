# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  
  class LineSegment < Struct.new(:first, :second)
    def inspect
      "(LineSegment #{first.inspect} #{second.inspect})"
    end

    # [[x1,y1],[x2,y2]]
    def to_a
      [first.to_a, second.to_a]	
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

    # Points by which we might navigate around this LineSegment.
    def ways_around
      [off_first, off_second]
    end

    def slope
      (second.y - first.y).to_f / (second.x - first.x)
    end
      
    def length
      first.distance(second)
    end

    def point?
      first == second
    end

    # Translated and adapted from: 
    # http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline2d/example.cpp
    # Returns true for coincident line segments; false for nonintersecting
    # segments; and the point of intersection for intersecting segments.
    def intersection_pt(other) 
      # TODO: Special-case where either is a point

      denom = ((other.second.y - other.first.y).to_f*(second.x - first.x)) -
              ((other.second.x - other.first.x).to_f*(second.y - first.y))
      numea = ((other.second.x - other.first.x).to_f*(first.y - other.first.y)) -
              ((other.second.y - other.first.y).to_f*(first.x - other.first.x))
      numeb = ((second.x - first.x).to_f*(first.y - other.first.y)) -
              ((second.y - first.y).to_f*(first.x - other.first.x))

      if denom.zero?
        if numea.zero? && numeb.zero?
          # Coincident; return closest endpoint to other.first
          return [first, second].sort_by{|p| p.distance(other.first)}.first
        else
          return nil # parallel
        end
      end
      
      ua = numea / denom
      ub = numeb / denom

      if (0.0..1.0).include?(ua) && (0.0..1.0).include?(ub)
        project(ua)
      else
        false
      end
    end

    alias_method :intersects?, :intersection_pt
  end

end
