require File.join(File.dirname(__FILE__), 'test_helper')

class PointTest < Test::Unit::TestCase
  
  context "A point" do
    setup do
      @point = Pathfinder::Point.new 1, 2
    end

    should "respond to #x and #y" do
      assert_equal 1, @point.x
      assert_equal 2, @point.y
    end

    should "convert to an Array using #to_a" do
      assert_equal [1,2], @point.to_a
    end

    should "output in ordered-pair notation upon #inspect" do
      assert_equal "(1,2)", @point.inspect
    end

    should "have distance zero from itself" do
      assert_equal 0.0, @point.distance(@point)
    end

    should "use the distance formula to calculate #distance" do
      origin = Pathfinder::Point.new 0,0
      assert_in_delta Math.sqrt(5), @point.distance(origin), 0.0001
    end
      

  end

end

