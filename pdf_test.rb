$: << 'lib'
require 'rubygems'
require 'pathfinder'

include Pathfinder
map = Map.generate_random
path = Path.new([0,0], [100,100], map)

pdf = map.to_pdf
path.draw(pdf)
#path.draw_event_angles(pdf)
pdf.render_file('out.pdf')

`open out.pdf`
