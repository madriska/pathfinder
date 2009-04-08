module Pathfinder
  # Represents a 2-dimensional map within which obstacles can be placed.
  class Map
    
    def initialize(width, height, obstacles)
      @width, @height, @obstacles = width, height, obstacles
    end
    
    def self.generate_random(options={})
      options = {
        :width => 100, 
        :height => 100,
        :num_obstacles => 5,
        :integral => true
      }.merge(options)

      width, height = options[:width], options[:height]

      obstacles = (1..options[:num_obstacles]).map do
        random = options[:integral] ? lambda{|x| rand(x) } : 
                                      lambda{|x| rand * x }
        LineSegment.new(Point.new(random[width], random[height]),
                        Point.new(random[width], random[height]))
      end

      new(width, height, obstacles)
    end

  end
end
