module Pathfinder
  class Point < Struct.new(:x, :y)

    def inspect
      "(#{x},#{y})"
    end

    def to_a
      [x, y]
    end

    def distance(other)
      Math.sqrt((other.x-x)**2 + (other.y-y)**2)
    end

  end
end
