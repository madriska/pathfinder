# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'enumerator'

module Pathfinder
  class Path

    # Yields [start, end] of each segment along the path.
    def each_segment(&block)
      if block
        steps.enum_for(:each_cons, 2).each(&block)
      else
        steps.enum_for(:each_cons, 2)
      end
    end

    # Furthest point along this path.
    def endpoint
      steps.last
    end

    def complete?
      endpoint == goal
    end

  end
end

