# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'pathfinder/memoize'

module Pathfinder
  # Represents a 2-dimensional map within which obstacles can be placed.
  class Map
    
    attr_reader :width, :height, :obstacles
    def initialize(width, height, obstacles)
      @width, @height, @obstacles = width, height, obstacles
    end
    
    def shortest_path(start, finish)
      best = nil
      paths = PrioritySet.new
      initial_path = Path.new(start, finish)
      paths.push(initial_path, initial_path.cost)
 
      seen = {} # to break cycles

      # TODO: prune search tree. Right now we're checking lots of paths that
      # aren't going to pan out.
      
      i = 0
      `mkdir -p out`
      `rm -rf out/*.pdf`

      while path = paths.pop
        # Save our progress
        pdf = to_pdf
        if best
          best.draw(pdf, '66ff66')
        end
        path.draw(pdf) if path
        pdf.render_file("out/%04d.pdf" % i)
        i += 1

        # print "#{paths.size} path#{"s" unless paths.size == 1} left#{' '*80}\r"
        seen[path.steps] = true
        if path.complete? && (best.nil? || (path.cost < best.cost))
          best = path
        end

        # Push feasible successors into path list
        successors(path).each do |p| 
          unless (best && (p.cost > best.cost))
            paths.push(p, p.cost) unless seen[p.steps]
          end
        end

      end

      if best # End on a good note
        pdf = to_pdf
        best.draw(pdf)
        pdf.render_file("out/%04d.pdf" % i)
      end

      best
    end

    # All obstacles in path of endpoint->target.
    def obstacles(path, target=nil)
      segment = LineSegment.new(path.endpoint, target || path.goal)
      @obstacles.select{|o| o.intersects?(segment)}
    end

    # Next obstacle, if any, along the path endpoint->target.
    # TODO: this algorithm can be improved
    def next_obstacle(path, target=nil)
      segment = LineSegment.new(path.endpoint, target || path.goal)
      obstacles(path, target).sort_by do |o|
        intersection = o.intersection_pt(segment)
        (intersection == true) ? 0 : path.endpoint.distance(intersection)
      end.first
    end
    memoize :next_obstacle

    # Returns a copy of self with next_node appended. Returns nil if
    # appending next_node would be stupid.
    def extend_path(path, next_node)
      return nil if path.steps.include?(next_node)
      return nil if next_node.x < 0 || next_node.y < 0 ||
                    next_node.x > width || next_node.y > height

      coalesce_end(dup_with_steps(path, path.steps + [next_node]))
    end

    # Returns a new version of path with the last segment simplified, if 
    # possible. If the path is ABCDE and BE is clear, the path returned
    # will be ABE. This method may return self if appropriate; it does not
    # dup unless changes are made.
    def coalesce_end(path)
      return path unless path.steps.size > 2

      end_step = path.steps[-1]
      path.steps[0..-3].each_with_index do |start_step, i|
        # Create a path that bypasses the intermediate node(s)
        simple_segment = LineSegment.new(start_step, end_step)
        if @obstacles.none?{|o| o.intersects?(simple_segment)}
          return dup_with_steps(path, path.steps[0..i] + [end_step])
        end
      end
      path
    end

    # Returns an array of augmented paths that advance toward +target+.
    # Ignores solutions that would pass through +goal_stack+.
    # +goal_stack+ is a list of points already being considered on the current
    # solution, to break infinite recursion (following the same line back/forth)
    def successors(path, target=nil, goal_stack=[])
      target ||= path.goal
      return [] if path.complete?

      ray = LineSegment.new(path.endpoint, target)
      if obstacle = next_obstacle(path, target)
        # back up and try to go around the obstacle we hit
        obstacle.ways_around(ray).reject{|x| goal_stack.include?(x)}.
          map{|x| successors(path, x, goal_stack + [x])}.flatten.compact
      else
        # go directly to goal
        [extend_path(path, target)].compact
      end
    end


    protected

    # Returns a copy of path, with +steps+ instead of its own.
    def dup_with_steps(path, steps)
      Path.new(steps.first, path.goal, steps[1..-1])
    end

    # Returns an array of four LineSegments corresponding to a rectangle 
    # axis-aligned, anchored at corner, and with dimensions (width, height).
    def self.rectangle(corner, width, height)
      c0 = corner
      c1 = Point.new(corner.x, corner.y + height)
      c2 = Point.new(corner.x + width, corner.y)
      c3 = Point.new(corner.x + width, corner.y + height)
      [LineSegment.new(c0, c1), LineSegment.new(c0, c2),
       LineSegment.new(c1, c3), LineSegment.new(c2, c3)]
    end


  end
end

