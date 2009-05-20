# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'pathfinder/compatibility'

require 'visilibity' # gem install visilibity

module Pathfinder
  # for epsilon geometry as used in VisiLibity
  Epsilon = 0.000001
end

require 'pathfinder/visilibity/point'
require 'pathfinder/visilibity/line_segment'
require 'pathfinder/visilibity/polygon'
require 'pathfinder/visilibity/map'
require 'pathfinder/visilibity/path'

require 'pathfinder/pdf'
require 'pathfinder/common'

