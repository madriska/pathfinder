# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'priority_set'

module Pathfinder
  # Represents a start and end point and a (potentially partial) path
  # connecting the start point to the end point. The path is composed of a 
  # series of +steps+, all of which are unimpeded except for 
  # +steps[gap_position]+. The "gap" is narrowed from either end until the
  # path is unimpeded.
  class Path
    
    attr_reader :steps, :map, :goal, :gap_position
    def initialize(start, goal, map, steps=nil, gap_position=nil)
      @steps = steps || [start, goal]
      @gap_position = gap_position || 1
      @map   = map
      @goal  = goal
    end

    def inspect
      "(Path goal=#{goal.inspect} steps=(#{steps.map{|s| s.inspect}.join(' ')}))"
    end

    def gap
      LineSegment.new(*@steps[@gap_position - 1, 2])
    end

    def complete?
      obstacles(*gap.to_a).empty?
    end

    # All obstacles in path of endpoint->target.
    def obstacles(origin, target)
      segment = LineSegment.new(origin, target)
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
    memoize :next_obstacle

    def shortest_path
      best = nil
      paths = PrioritySet.new
      paths.push(self, cost)
 
      seen = {} # to break cycles

      # TODO: prune search tree. Right now we're checking lots of paths that
      # aren't going to pan out.
      while path = paths.pop
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
    def each_segment(&block)
      @steps.each_cons(2, &block)
    end

    def cost
      each_segment.inject(0){|sum, (a,b)| sum + a.distance(b)}
    end

    # Returns an array of augmented paths that advance toward +target+.
    # Ignores solutions that would pass through +goal_stack+.
    # +goal_stack+ is a list of points already being considered on the current
    # solution, to break infinite recursion (following the same line back/forth)
    def successors(target=goal, goal_stack=[])
      return [] if complete?

      ray = LineSegment.new(endpoint, target)
      if obstacle = next_obstacle(target)
        # back up and try to go around the obstacle we hit
        obstacle.ways_around(ray).reject{|x| goal_stack.include?(x)}.
          map{|x| successors(x, goal_stack + [x])}.flatten.compact
      else
        # go directly to goal
        [extend_path(target)].compact
      end
    end

    protected

    # Returns a copy of self with next_node appended. Returns nil if
    # appending next_node would be stupid.
    def extend_path(next_node)
      return nil if @steps.include?(next_node)
      return nil if next_node.x < 0 || next_node.y < 0 ||
                    next_node.x > @map.width || next_node.y > @map.height

      dup_with_steps(@steps + [next_node]).coalesce_end
    end

    # Returns a new version of self with the last segment simplified, if 
    # possible. If the path is ABCDE and BE is clear, the path returned
    # will be ABE. This method may return self if appropriate; it does not
    # dup unless changes are made.
    def coalesce_end
      return self unless @steps.size > 2

      # Create a path that bypasses the second-to-last node
      simple_segment = LineSegment.new(@steps[-3], @steps[-1])
      if @map.obstacles.none?{|o| o.intersects?(simple_segment)}
        # Recurse -- see if the simplified path can be further simplified
        return dup_with_steps(@steps[0..-3] + [@steps[-1]]).coalesce_end
      end
      self
    end

    # Returns a copy of self, with +steps+ instead of my own.
    def dup_with_steps(steps)
      self.class.new(steps.first, @goal, @map, steps[1..-1])
    end

  end
end
