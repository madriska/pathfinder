module Pathfinder
  class Point < Struct.new(:x, :y)

    def inspect
      "(#{x},#{y})"
    end

  end
end
