$: << 'lib'
require 'rubygems'
require 'pathfinder'

include Pathfinder
map = Map.generate_random(:num_obstacles => 50, :integral => false)
path = Path.new(Point.new(0,0), Point.new(100,100), map)

pdf = map.to_pdf
path = path.shortest_path
path.draw(pdf) if path
#path.draw_event_angles(pdf)
pdf.render_file('out.pdf')

`open out.pdf`
