module Pathfinder
  
  class LineSegment < Struct.new(:first, :second)
    def inspect
      "(LineSegment #{first.inspect} #{second.inspect})"
    end
      
    # [[x1,y1],[x2,y2]]
    def to_a
      [first.to_a, second.to_a]	
    end
  end

end
