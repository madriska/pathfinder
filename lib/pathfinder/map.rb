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
    
    def self.generate_random(options={})
      options = {
        :width => 100, 
        :height => 100,
        :integral => true,
        :num_obstacles => 20
      }.merge(options)

      width, height = options[:width], options[:height]

      obstacles = (1..options[:num_obstacles]).map do
        random = options[:integral] ? lambda{|x| rand(x) } : 
                                      lambda{|x| rand * x }
        x, y = random[width], random[height]

        # x2 = random in x-limit..x+limit
        limit = width / 4
        x2 = x + random[2*limit] - limit
        y2 = y + random[2*limit] - limit

        LineSegment.new(Point.new(x, y), 
                        Point.new([0, [x2, width].min].max, 
                                  [0, [y2, height].min].max))
      end

      new(width, height, obstacles)
    end


  end
end

