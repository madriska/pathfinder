# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  # Represents a 2-dimensional map within which obstacles can be placed.
  class Map
    
    attr_reader :width, :height, :obstacles
    def initialize(width, height, obstacles)
      @width, @height, @obstacles = width, height, obstacles
    end
    

    protected

    # Returns an array of four LineSegments corresponding to a rectangle 
    # axis-aligned, anchored at corner, and with dimensions (width, height).
    def self.rectangle(corner, width, height)
      c0 = corner
      c1 = Point.new(corner.x, corner.y + height)
      c2 = Point.new(corner.x + width, corner.y)
      c3 = Point.new(corner.x + width, corner.y + height)
      [LineSegment.new(c0, c1), LineSegment.new(c0, c2),
       LineSegment.new(c1, c3), LineSegment.new(c2, c3)]
    end


  end
end

