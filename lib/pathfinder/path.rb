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

    # All obstacles in path of endpoint->target.
    def obstacles(target = goal)
      segment = LineSegment.new(endpoint, target)
      @map.obstacles.select{|o| o.intersects?(segment)}
    end

    # Next obstacle, if any, along the path endpoint->target.
    # TODO: this algorithm can be improved
    def next_obstacle(target = goal)
      segment = LineSegment.new(endpoint, target)
      obstacles(target).sort_by do |o|
        intersection = o.intersection_pt(segment)
        endpoint.distance(intersection)
      end.first
    end

    def shortest_path
      best = nil
      paths = [self]
      until paths.empty?
        path = paths.shift
        puts "Path: #{path.inspect}"
        best = path if !best || (path.cost < best.cost)
        paths.concat(path.successors)
      end
      best
    end

    def cost
      # TODO: include cost of nodes already traversed
      endpoint.distance(goal)
    end

    def successors
      return [] if complete?
      line = next_obstacle
      if line.nil?
        # go directly to goal
        [extend_path(goal)].compact
      else
        # TODO: fix up to check for intersections first
        [extend_path(line.off_first), 
         extend_path(line.off_second)].compact
      end
    end

    # Returns a copy of self with next_node appended. Returns nil if
    # appending next_node would be stupid (if we've already visited that).
    def extend_path(next_node)
      return nil if @steps.include?(next_node)
      self.class.new(@steps.first, @goal, @map,
                     (@steps[1..-1] + [next_node]))
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
