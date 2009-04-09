module Pathfinder
  class Point < Struct.new(:x, :y)

    def inspect
      "(#{x},#{y})"
    end

    def to_a
      [x, y]
    end

  end
end
