require 'priority_set'

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

    def inspect
      "(Path goal=#{goal.inspect} steps=(#{steps.map{|s| s.inspect}.join(' ')}))"
    end

    # Furthest point along this path.
    def endpoint
      @steps.last
    end

    def complete?
      endpoint == goal
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
        (intersection == true) ? 0 : endpoint.distance(intersection)
      end.first
    end

    def shortest_path
      best = nil
      paths = PrioritySet.new
      paths.push(self, cost)
 
      seen = {} # to break cycles

      # TODO: prune search tree. Right now we're checking lots of paths that
      # aren't going to pan out.
      while path = paths.pop
        # print "#{paths.size} path#{"s" unless paths.size == 1} left#{' '*80}\r"
        seen[path.steps] = true
        best = path if path.complete? && (best.nil? || (path.cost < best.cost))

        # Push feasible successors into path list
        path.successors.each do |p| 
          unless (best && (p.cost > best.cost))
            paths.push(p, p.cost) unless seen[p.steps]
          end
        end

      end
      best
    end
    
    # Yields [start, end] of each segment along the path.
    # TODO: should this yield LineSegments?
    def each_segment
      @steps.each_cons(2)
    end

    def cost
      each_segment.inject(0){|sum, (a,b)| sum + a.distance(b)}
    end

    # Returns an array of augmented paths that advance toward +target+.
    # Ignores solutions that would pass through +goal_stack+.
    def successors(target=goal, goal_stack=[])
      return [] if complete?
      line = next_obstacle(target)
      if line.nil?
        # go directly to goal
        [extend_path(target)].compact
      else
        # back up and try to go around the line we hit
        # +goal_stack+ is a list of points being considered,
        # to break infinite recursion (following the same line back/forth)
        [line.off_first, line.off_second].reject{|x| goal_stack.include?(x)}.
          map{|x| successors(x, goal_stack + [x])}.flatten.compact
      end
    end

    protected

    # Returns a copy of self with next_node appended. Returns nil if
    # appending next_node would be stupid.
    def extend_path(next_node)
      return nil if @steps.include?(next_node)
      return nil if next_node.x < 0 || next_node.y < 0 ||
                    next_node.x > @map.width || next_node.y > @map.height

      # Coalesce with last segment if that route doesn't intersect any obstacles
      if @steps.size > 1
        simple_segment = LineSegment.new(@steps[-2], next_node)
        if @map.obstacles.none?{|o| o.intersects?(simple_segment)}
          return dup_with_steps(@steps[0..-2] + [next_node])
        end
      end
      dup_with_steps(@steps + [next_node])
    end

    # Returns a copy of self, with +steps+ instead of my own.
    def dup_with_steps(steps)
      self.class.new(steps.first, @goal, @map, steps[1..-1])
    end

  end
end
