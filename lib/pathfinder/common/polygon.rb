# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Pathfinder
  class Polygon

    def self.disc(center, radius, segments)
      segment_angle = 2 * Math::PI / segments
      vertices = (0...segments).map do |i|
        angle = segment_angle * i
        center + Point.new(radius * Math.cos(angle), radius * Math.sin(angle))
      end
      new(vertices)
    end

    def self.generate_random(options)
      options = {:max_sides => 6, :divergence => options[:width] / 4.0}.
        merge(options)

      sides = rand(options[:max_sides] - 2) + 3
      center = Point.random(options[:width], options[:height])

      points = (1..sides).map do
        center.random_divergence(options[:divergence], 
                                 options[:divergence]).
               clamp(options[:width], options[:height])
      end
      
      # Turn into simple polygon: sort vertices by their angle from centroid
      centroid = Point.new(points.inject(0){|s,p| s + p.x} / points.size,
                           points.inject(0){|s,p| s + p.y} / points.size)
      new(points.sort_by{|p| centroid.angle_to(p)})
    end

    def intersects?(x)
      case x
      when LineSegment
        segments.any?{|s| s.intersects?(x)}
      when Polygon
        segments.any?{|s| x.segments.any?{|t| s.intersects?(t)}}
      end
    end

    def segments
      vertices.enum_for(:each_cons, 2).map{|a,b| LineSegment.new(a, b)} +
        [LineSegment.new(vertices.last, vertices.first)]
    end
    memoize :segments

  end
end

