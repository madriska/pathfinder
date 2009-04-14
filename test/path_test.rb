require File.join(File.dirname(__FILE__), 'test_helper')

class PathTest < Test::Unit::TestCase
  include Pathfinder

  def create_path(options={})
    options = {:start => Point.new(0,0),
               :goal  => Point.new(100,100),
               :map   => Map.generate_random,
               :steps => []}.merge(options)
    Pathfinder::Path.new(options[:start], options[:goal], options[:map],
                         options[:steps])
  end
  
  should "not be recognized as complete? if not yet at goal" do
    path = create_path
    assert !path.complete?
  end

  should "be recognized as complete? if path ends at goal" do
    path = create_path(:steps => [Point.new(100,100)],
                       :goal  => Point.new(100,100))
    assert path.complete?
  end

  should "detect an obstacle perpendicular to straight-line path to goal" do
    obstacle = LineSegment.new(Point.new(0, 100), Point.new(100, 0))
    map  = Map.new(100, 100, [obstacle])
    path = create_path(:map => map)
    
    assert_equal [obstacle], path.obstacles
    assert_equal obstacle, path.next_obstacle
  end

  should "detect an obstacle coincident with straight-line path to goal" do
    obstacle = LineSegment.new(Point.new(10, 10), Point.new(90, 90))
    map  = Map.new(100, 100, [obstacle])
    path = create_path(:map => map)
    
    assert_equal [obstacle], path.obstacles
    assert_equal obstacle, path.next_obstacle
  end

end



