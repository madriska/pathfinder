# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Map < VisiLibity::Environment
    InvalidMap = Class.new(StandardError)
    
    attr_reader :width, :height, :obstacles
    def initialize(width, height, obstacles)
      @width = width
      @height = height
      @obstacles = obstacles # used in pdf.rb for drawing them

      boundary = VisiLibity::Polygon.new([VisiLibity::Point.new(0,0),
                                         VisiLibity::Point.new(width,0),
                                         VisiLibity::Point.new(width,height),
                                         VisiLibity::Point.new(0,height)])
      super([boundary] + obstacles)
    end

    def shortest_path(start, finish, epsilon=Epsilon)
      # Reorder boundary vertices ccw and holes cw
      enforce_standard_form
      raise InvalidMap unless valid?(Pathfinder::Epsilon)

      polyline = super
      return nil unless polyline
      # Wrap result in Path
      Path.new(start, finish, polyline.vertices[1..-1])
    end

  end
end


