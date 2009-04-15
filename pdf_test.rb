# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

$: << 'lib'
require 'rubygems'
require 'pathfinder'

include Pathfinder
map = Map.generate_random(:num_obstacles => 10, :integral => false)
path = Path.new(Point.new(0,0), Point.new(100,100), map)

pdf = map.to_pdf
path = path.shortest_path
path.draw(pdf) if path
pdf.render_file('out.pdf')

`open out.pdf`
