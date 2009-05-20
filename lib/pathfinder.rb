# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

begin
  require 'pathfinder/visilibity'
rescue LoadError
  puts "VisiLibity not found. Using pure Ruby implementation; gem install visilibity for the native implementation."
  require 'pathfinder/pure'
end
