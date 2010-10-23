require 'test_helper'

class AdventureTest < Test::Unit::TestCase
  
  def test_add_room
    adventure = Adventure.new
    adventure.add_room :shopping_mall, :description => "An empty shopping mall"
    
    assert_equal 1, adventure.rooms.size
    assert_equal :shopping_mall, adventure.rooms.first.name
    assert_equal "An empty shopping mall", adventure.rooms.first.description
  end
  
  def test_current_room_is_first_room_added
    adventure = Adventure.new
    adventure.add_room :shopping_mall
    adventure.add_room :parking_lot

    assert_equal :shopping_mall, adventure.current_room.name 
  end
  
  def test_go_to_different_room
    adventure = Adventure.new
    adventure.add_room :shopping_mall, :south => :parking_lot
    adventure.add_room :parking_lot, :description => "A scary parking lot"
    
    adventure.go :south
    
    assert_equal :parking_lot, adventure.current_room.name
  end

  def test_go_to_non_existant_room
    adventure = Adventure.new
    adventure.add_room :shopping_mall, :south => :parking_lot
    adventure.add_room :parking_lot, :description => "A scary parking lot"
    
    adventure.go :west
    
    assert_equal :shopping_mall, adventure.current_room.name
  end

  
  def test_user_command
    adventure = Adventure.new
    adventure.add_room :shopping_mall, :south => :parking_lot
    adventure.add_room :parking_lot, :description => "A scary parking lot"
    
    adventure.command "go south"
    
    assert_equal :parking_lot, adventure.current_room.name
  end
  
end