# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

$: << 'lib'
require 'rubygems'

require 'pathfinder'

include Pathfinder
map = Map.generate_random(:num_obstacles => 20, :integral => false)

pdf = map.to_pdf

start = Point.new(rand*100, rand*100)
finish = Point.new(rand*100, rand*100)
path = map.shortest_path(start, finish)

path.draw(pdf) if path
pdf.render_file('out.pdf')

`open out.pdf`
