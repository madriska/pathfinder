require File.join(File.dirname(__FILE__), 'test_helper')

class MapTest < Test::Unit::TestCase
  
  context "Random map generation" do
    
    should "respect :width, :height, and :num_obstacles options" do
      map = Pathfinder::Map.generate_random(:width => 123, :height => 456,
                                            :num_obstacles => 33)
      assert_equal 123, map.width
      assert_equal 456, map.height
      assert_equal 33, map.obstacles.size
    end

    should "only return integral values for :integral => true" do
      map = Pathfinder::Map.generate_random(:integral => true)
      assert_kind_of Integer, map.obstacles.first.first.x
    end
    
    should "return non-integral values for :integral => false" do
      map = Pathfinder::Map.generate_random(:integral => false)
      assert_kind_of Float, map.obstacles.first.first.x
    end

  end

end


