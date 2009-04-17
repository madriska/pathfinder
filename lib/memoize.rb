# Copyright 2009 Brad Ediger. All rights reserved.
# This is copyrighted free software. Please see the LICENSE and COPYING files
# for details.

module Kernel
  def memoize(id)
    alias_method :"_memo_original_#{id}", id

    class_eval <<-RUBY
      def #{id}(*args)
        @_memoized_#{id} ||= Hash.new {|h, args| 
          h[args] = _memo_original_#{id}(*args)
        }
        @_memoized_#{id}[args]
      end
    RUBY
  end
end
