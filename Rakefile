require 'rubygems'
require 'rake'
require 'rake/testtask'

task :default => [:test]

Rake::TestTask.new do |test|
  test.test_files = Dir[ "test/*_test.rb" ]
end

