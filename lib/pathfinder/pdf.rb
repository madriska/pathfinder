# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

# PDF-output extensions for Pathfinder.
# Uses Prawn (http://prawn.majesticseacreature.com/).

module Pathfinder

  begin
    require 'prawn'

    module PDF
      extend self

      Scale = 4.0
      def scale(p)
        (p.is_a?(Array) ? p : p.to_a).map{|x| x*Scale}
      end
    end
    
    class LineSegment
      def draw(pdf)
        pdf.stroke_line to_a.map{|pt| PDF.scale(pt)}
      end
    end

    class Polygon
      def draw(pdf)
        pdf.fill_color = '666666'
        pdf.fill_polygon *@vertices.map{|v| PDF.scale(v)}
      end
    end

    class Map
      def to_pdf
        margin = 0.5 * 72 # 1/2 inch
        width  = (PDF::Scale * @width) + (2 * margin)
        height = (PDF::Scale * @height) + (2 * margin)

        Prawn::Document.new(:page_size => [width, height],
                            :margin    => margin) do |pdf|
          pdf.stroke_rectangle(PDF.scale([0, @height]), 
                               @width*PDF::Scale, @height*PDF::Scale)
          @obstacles.each do |obstacle|
            obstacle.draw(pdf)
          end
        end
      end
    end

    class Path

      # Draw self onto +pdf+.
      def draw(pdf)
        pdf.stroke_color = '00ff00'
        each_segment do |first, second|
          pdf.stroke_line(PDF.scale(first), PDF.scale(second))
        end
      end

    end

  rescue LoadError # no prawn
  end

end

