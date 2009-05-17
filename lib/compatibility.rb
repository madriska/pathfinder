# Ruby 1.8 compatibility fixes.

unless [].methods.include?('none?')
  module Enumerable
    def none?
      each {|x| return false if yield(x) }
      true
    end
  end
end

