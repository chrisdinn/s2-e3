require 'test_helper'

class RoomTest < Test::Unit::TestCase
  
  def test_name
    room = Adventure::Room.new :shopping_mall
    
    assert_equal :shopping_mall, room.name
  end
  
  def test_description
    description = "An empty shopping mall"
    room = Adventure::Room.new :shopping_mall, :description => description
    
    assert_equal description, room.description
  end
  
  def test_path
    mall = Adventure::Room.new :shopping_mall
    parking_lot = Adventure::Room.new :parking_lot, :north => :shopping_mall
    
    assert_equal :shopping_mall, parking_lot.north
  end
  
end