require 'test_helper'

class RoomTest < Test::Unit::TestCase
  
  def test_name
    room = Room.new :shopping_mall
    
    assert_equal :shopping_mall, room.name
  end
  
  def test_description
    description = "An empty shopping mall"
    room = Room.new :shopping_mall, :description => description
    
    assert_equal description, room.description
  end
  
  def test_path
    mall = Room.new :shopping_mall
    parking_lot = Room.new :parking_lot, :north => :shopping_mall
    
    assert_equal :shopping_mall, parking_lot.north
  end
  
end