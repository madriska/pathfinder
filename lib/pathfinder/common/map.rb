# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Map

    def self.generate_random(options={})
      options = {
        :width => 100, 
        :height => 100,
        :integral => true,
        :num_obstacles => 1
      }.merge(options)

      width, height = options[:width], options[:height]

      obstacles = (1..options[:num_obstacles]).inject([]) do |polys, _|
        p = Polygon.generate_random(:width => width, :height => height)
        while polys.any?{|q| p.intersects?(q)}
          p = Polygon.generate_random(:width => width, :height => height)
        end
        polys + [p]
      end

      new(width, height, obstacles)
    end

  end
end

