# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

require 'algorithms' # gem install algorithms
require 'set'

# A priority queue that ignores duplicates.
class PrioritySet < Containers::PriorityQueue
  
  def initialize(*args)
    @set = Set.new
    super
  end

  def push(item, priority)
    unless @set.include?(item)
      @set << item
      super
    end
  end

  def clear
    @set = Set.new
    super
  end

  def pop
    item = super
    @set.delete(item)
    item
  end
  
  def delete(priority)
    item = super
    @set.delete(item)
    item
  end

end
