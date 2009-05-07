# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'priority_set'

module Pathfinder
  # Represents a start and end point and a (potentially partial) path
  # connecting the start point to the end point. The path is composed of a 
  # series of steps, stored in two parts separated by a "gap": a partial
  # unimpeded path from the beginning, and a partial unimpeded path to the end.
  # The gap is closed
  class Path
    
    attr_reader :steps, :map
    def initialize(start, goal, map, steps=nil)
      @steps = steps || [[start], [goal]]
      @map   = map
    end
    
    def initial_steps
      steps.first
    end

    def final_steps
      steps.last
    end

    def goal
      final_steps.last
    end

    def gap
      LineSegment.new(initial_steps.last, final_steps.first)
    end

    def complete?
      initial_steps.last == final_steps.first # gap empty
    end

    # All obstacles in path of endpoint->target.
    def obstacles(origin, target)
      segment = LineSegment.new(origin, target)
      @map.obstacles.select{|o| o.intersects?(segment)}
    end

    # TODO: to improve situations where target is inaccessible,
    # at each step randomly choose which end of the gap to narrow.
    # This should allow us to find out more quickly if the goal
    # is inaccessible. And generally, problems may be more tractable
    # from one end than another.

    # Next obstacle, if any, along the path endpoint->target.
    # TODO: this algorithm can be improved
    def next_obstacle(origin, target)
      segment = LineSegment.new(origin, target)
      #puts "Obstacles(#{origin.inspect}, #{target.inspect}) = #{obstacles(origin, target).inspect}"
      obstacles(origin, target).sort_by do |o|
        intersection = o.intersection_pt(segment)
        (intersection == true) ? 0 : origin.distance(intersection)
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
        if path.complete? && (best.nil? || (path.cost < best.cost))
          puts "New best: #{path.inspect}"
          best = path
          return best
        end

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
      initial_steps.each_cons(2, &block)
      final_steps.each_cons(2, &block)
    end

    def cost
      each_segment.inject(0){|sum, (a,b)| sum + a.distance(b)}
    end

    # Returns an array of augmented paths that advance toward +target+.
    # Ignores solutions that would pass through +goal_stack+.
    # +goal_stack+ is a list of points already being considered on the current
    # solution, to break infinite recursion (following the same line back/forth)
    def successors(origin=nil, destination=nil, goal_stack=[])
      origin ||= gap.first
      destination ||= gap.second
      return [] if complete? || origin == destination

      # Randomly decide which endpoint of the gap to work on.
      # This helps us work around obstacles that are easier to work from one
      # side than from the other; in the extreme case, consider an obstacle 
      # very close to the goal, blocking it completely. With high probability,
      # we will figure this out before wasting a bunch of time figuring out
      # how to get close to the goal.
      swap = (rand > 0.5)
      #origin, destination = destination, origin if swap

      #puts "Origin, destination = #{origin.inspect}, #{destination.inspect}"
      ray = LineSegment.new(origin, destination)
      if obstacle = next_obstacle(origin, destination)
        # back up and try to go around the obstacle we hit
        #puts "pushing onto stack"
        obstacle.ways_around(ray).reject{|x| goal_stack.include?(x)}.
          map{|x| successors(origin, x, goal_stack + [x])}.flatten.compact
      else
        # narrow the gap
        # swap back if needed
        #origin, destination = destination, origin if swap
        if origin == initial_steps.last
          [dup_with_steps([initial_steps + [destination],
                          final_steps])]
        else # origin == final_steps.first
          [dup_with_steps([initial_steps, 
                          [destination] + final_steps])]
        end
      end
    end

    protected

    # Conses +new_step+ onto +steps+, simplifying the end of the path as needed.
    def coalesce(steps, new_step)
      return [*steps, new_step] #if steps.length < 2
      simple_segment = LineSegment.new(steps[-2], new_step)
      if @map.obstacles.none?{|o| o.intersects?(simple_segment)}
        # Recurse -- see if the simplified path can be further simplified
        coalesce(steps[0..-2], new_step)
      else
        [*steps, new_step]
      end
    end

    # Returns a copy of self, with +steps+ instead of my own.
    def dup_with_steps(steps)
      self.class.new(nil, nil, @map, steps)
    end

  end
end
