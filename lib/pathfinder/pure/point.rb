# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Point < Struct.new(:x, :y)

    def distance(other)
      Math.sqrt((other.x-x)**2 + (other.y-y)**2)
    end

  end
end
