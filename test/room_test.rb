require 'test_helper'

class RoomTest < Test::Unit::TestCase
  
  def test_name
    room = Adventure::Room.new "shopping mall"
    
    assert_equal "shopping mall", room.name
  end
  
  def test_description
    description = "An empty shopping mall"
    room = Adventure::Room.new "shopping_mall", :description => description
    
    assert_equal description, room.description
  end
  
  def test_path
    mall = Adventure::Room.new "shopping mall"
    parking_lot = Adventure::Room.new "parking_lot", :north => "shopping mall"
    
    assert_equal "shopping mall", parking_lot.north
  end
  
  def test_add_item
    room = Adventure::Room.new "shopping mall"
    room.add_item "esclator", :description => "An old escalator"
    
    assert_equal 1, room.items.size
    assert_equal "esclator", room.items.first.name
    assert_equal "An old escalator", room.items.first.description
  end
  
  def test_look_at_item
    room = Adventure::Room.new "shopping mall"
    room.add_item "an escalator", :description => "An old escalator"
    
    assert_equal "An old escalator", room.look_at("escalator")
  end
  
  def test_look_at_non_existant_item
    room = Adventure::Room.new "shopping mall"
    room.add_item "escalator", :description => "An old escalator"
    
    assert_equal nil, room.look_at("stairs")
  end
  
end