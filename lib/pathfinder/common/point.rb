# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Point

    def self.random(width, height)
      new(rand(width.to_f), rand(height.to_f))
    end

    def random_divergence(divx, divy=nil)
      divy ||= divx
      dx = rand(divx.to_f) - divx/2.0
      dy = rand(divy.to_f) - divy/2.0
      self.class.new(x + dx, y + dy)
    end

    # Returns the angle of the line segment to +other+.
    def angle_to(other)
      Math.atan2(other.y - y, other.x - x)
    end

    # Clamps x to [0,w] and y to [0,h]
    def clamp(w, h)
      x2 = [[x, 0].max, w].min
      y2 = [[y, 0].max, h].min
      self.class.new(x2, y2)
    end

  end
end

