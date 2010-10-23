require 'test_helper'

class AdventureTest < Test::Unit::TestCase
  
  def test_add_room
    adventure = Adventure.new
    adventure.add_room "shopping mall", :description => "An empty shopping mall"
    
    assert_equal 1, adventure.rooms.size
    assert_equal "shopping mall", adventure.rooms.first.name
    assert_equal "An empty shopping mall", adventure.rooms.first.description
  end
  
  def test_current_room_is_first_room_added
    adventure = Adventure.new
    adventure.add_room "shopping mall"
    adventure.add_room "parking lot"

    assert_equal "shopping mall", adventure.current_room.name 
  end
  
  def test_go_to_different_room
    adventure = Adventure.new
    adventure.add_room "shopping mall", :south => "parking lot"
    adventure.add_room "parking lot", :description => "A scary parking lot"
    
    adventure.go :south
    
    assert_equal "parking lot", adventure.current_room.name
  end

  def test_go_to_non_existant_room
    adventure = Adventure.new
    adventure.add_room :shopping_mall, :south => :parking_lot
    adventure.add_room :parking_lot, :description => "A scary parking lot"
    
    adventure.go :west
    
    assert_equal :shopping_mall, adventure.current_room.name
  end
  
  def test_go_command
    adventure = Adventure.new
    adventure.add_room "shopping mall", :south => "parking lot"
    adventure.add_room "parking lot", :description => "A scary parking lot"
    
    adventure.command "go south"
    
    assert_equal "parking lot", adventure.current_room.name
  end
  
  def test_look_command
    description = "A friendly shopping mall"
    adventure = Adventure.new
    adventure.add_room "shopping mall", :description => description

    assert_match /#{description}/, adventure.command("look")
  end
  
  def test_look_at_item_command
    description = "A rickety old shopping cart."
    adventure = Adventure.new
    adventure.add_room "shopping mall"
    adventure.current_room.add_item "a shopping cart", :description => description

    assert_match /#{description}/, adventure.command("look at shopping cart")
  end
  
  def test_unrecognized_command
    adventure = Adventure.new

    assert_match /what?|huh?|don't understand that/, adventure.command("not a command")
  end
  
  def test_load_adventure_from_yaml
    adventure = Adventure.from_file('test/test_adventure.yml')
    
    assert_equal 2, adventure.rooms.size
    assert_equal "shopping mall", adventure.current_room.name
    #assert_equal "ladder", adventure.current_room.items.first.name

    assert_equal "parking lot", adventure.rooms.last.name
    assert_equal "parking lot", adventure.current_room.paths[:north]
  end
  
end