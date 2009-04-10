module Pathfinder
  # Represents a start and end point and a (potentially partial) path
  # from the start point toward the end point.
  class Path
    
    attr_reader :steps, :map, :goal
    def initialize(start, goal, map, steps=[])
      @steps = [start] + steps
      @map   = map
      @goal  = goal
    end

    # Furthest point along this path.
    def endpoint
      @steps.last
    end

    def complete?
      endpoint == goal
    end

    def event_points
      @map.obstacles.map{|o| [o.first, o.second]}.flatten
    end

    # Returns an array of angles (in radians) from the current endpoint
    # at which obstacles start/stop.
    # TODO: do visibility analysis on this first
    def event_angles
      event_points.map do |pt|
        Math.atan2(pt.y - endpoint.y, pt.x - endpoint.x)
      end.sort_by{|a| (a - angle(goal)).abs}
    end

    def segment_angles
      @map.obstacles.sort_by{|o| angle(o.first)}
    end

    # Next obstacle, if any, along the path endpoint->target.
    def next_obstacle(target = goal)
      segment = LineSegment.new(endpoint, target)
      @map.obstacles.select{|o| o.intersects?(segment)}.sort_by do |o|
        # TODO
      end.first
    end

    def shortest_path
      best = nil
      paths = [self]
      until paths.empty?
        path = paths.shift
        # TODO
      end
      best
    end
    

    protected

    def angle(to)
      Math.atan2(to.y - endpoint.y, to.x - endpoint.x)
    end

    def radius(to)
      Math.sqrt((to.y - endpoint.y)**2 + (to.x - endpoint.x)**2)
    end

  end
end
