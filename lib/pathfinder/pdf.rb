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

    class Map
      def to_pdf
        margin = 0.5 * 72 # 1/2 inch
        width  = (PDF::Scale * @width) + (2 * margin)
        height = (PDF::Scale * @height) + (2 * margin)

        Prawn::Document.new(:page_size => [width, height],
                            :margin    => margin) do |pdf|
          pdf.stroke_rectangle(PDF.scale([0, @height]), 
                               @width*PDF::Scale, @height*PDF::Scale)
          @obstacles.each do |segment|
            pdf.stroke_line segment.map{|pt| PDF.scale(pt)}
          end
        end
      end
    end

    class Path

      # Draw self onto +pdf+.
      def draw(pdf)
        pdf.stroke_color = '00ff00'
        steps.each_cons(2) do |first, second|
          pdf.stroke_line(PDF.scale(first), PDF.scale(second))
        end
        pdf.stroke_color = '999999'
        pdf.stroke_line(PDF.scale(endpoint), PDF.scale(goal))
        
        # next obstacle and its intersection
        pdf.stroke_color = 'ff0000'
        o = next_obstacle
        pdf.stroke_line(PDF.scale(o.first), PDF.scale(o.second))
        pdf.fill_color = '000000'
        pdf.fill_circle_at(PDF.scale(o.intersection_pt(
                              LineSegment.new(endpoint, goal))),
                           :radius => 3)
      end

      def draw_event_angles(pdf)
        event_points.each do |pt|
          pdf.stroke_color = 'ff0000'
          pdf.stroke_line(PDF.scale(endpoint), PDF.scale(pt))
        end
        pdf
      end

    end

  rescue LoadError # no prawn
  end

end

