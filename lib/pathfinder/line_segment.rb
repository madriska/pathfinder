module Pathfinder
  
  class LineSegment < Struct.new(:first, :second)
    def inspect
      "(LineSegment #{first.inspect} #{second.inspect})"
    end
  end

end
