$: << 'lib'
require 'rubygems'
require 'pathfinder'

include Pathfinder
map = Map.generate_random
path = Path.new(Point.new(0,0), Point.new(100,100), map)

pdf = map.to_pdf
path = path.shortest_path
path.draw(pdf)
#path.draw_event_angles(pdf)
pdf.render_file('out.pdf')

`open out.pdf`
