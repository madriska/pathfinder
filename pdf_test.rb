# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

$: << 'lib'
require 'rubygems'

require 'pathfinder/pure'

include Pathfinder
map = Map.generate_random(:num_obstacles => 20, :integral => false)

pdf = map.to_pdf

if defined?(VisiLibity)
  start = Point.new(rand*100, rand*100) until start && start.in(map)
  finish = Point.new(rand*100, rand*100) until finish && finish.in(map)
else
  start = Point.new(rand*100, rand*100)
  finish = Point.new(rand*100, rand*100)
end

start = Point.new(0,0)
finish = Point.new(100,100)

path = map.shortest_path(start, finish)

path.draw(pdf) if path
pdf.render_file('out.pdf')

require 'fileutils'
Dir["out/*.jpg"].each{|f| FileUtils.rm f}

print "Converting images to jpeg"
Dir["out/*.pdf"].each do |file|
  system "convert -colorspace XYZ -quality 100 #{file} #{file.gsub("pdf","jpg")} >/dev/null 2>&1"
  FileUtils.rm file
  print "."
  $stdout.flush
end
puts "Done."

print "Converting to mp4..."
FileUtils.rm_f "out.mp4"
system "ffmpeg -r 30 -b 800000 -i out/%04d.jpg out.mp4"
puts "Done."

system "open out.mp4" if File.exist?('out.mp4')

