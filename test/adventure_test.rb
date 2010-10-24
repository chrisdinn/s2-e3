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
  
  def test_pick_up_command
    adventure = Adventure.new
    adventure.add_room "shopping mall"
    adventure.current_room.add_item "a shopping bag"

    adventure.command("pick up shopping bag")

    assert_equal 1, adventure.inventory.size
    assert_equal "a shopping bag", adventure.inventory.first.name
  end
  
  def test_take_alias_for_pick_up
    adventure = Adventure.new
    adventure.add_room "shopping mall"
    adventure.current_room.add_item "a shopping bag"

    adventure.command("take shopping bag")

    assert_equal 1, adventure.inventory.size
    assert_equal "a shopping bag", adventure.inventory.first.name
  end

  def test_drop_command
    adventure = Adventure.new
    adventure.add_room "shopping mall", :south => "parking lot"
    adventure.add_room "parking lot", :description => "Empty lot"
    adventure.current_room.add_item "a shopping bag"
    
    adventure.command("pick up shopping bag")
    adventure.command("go south")
    adventure.command("drop shopping bag")
    
    assert_equal "parking lot", adventure.current_room.name
    assert_equal 1, adventure.current_room.items.size
    assert_equal 0, adventure.inventory.size
    assert_equal "a shopping bag", adventure.current_room.items.first.name
  end
  
  def test_use_command
    adventure = Adventure.new
    adventure.add_room "shopping mall", :south => "parking lot"
    adventure.current_room.add_item "fireworks", :message => "a beautiful boom"
    
    adventure.command "pick up fireworks"
    
    assert_match /a beautiful boom/, adventure.command("use fireworks")
  end
  
  def test_unrecognized_command
    adventure = Adventure.new

    assert_match /what?|huh?|don't understand that/, adventure.command("not a command")
  end
  
  def test_load_adventure_from_yaml
    adventure = Adventure.from_file('test/test_adventure.yml')
    
    assert_equal "Test adventure", adventure.title
    assert_equal "Welcome message", adventure.greeting
    
    assert_equal 2, adventure.rooms.size
    assert_equal "shopping mall", adventure.current_room.name
    assert_equal "parking lot", adventure.current_room.paths[:north]
    
    assert_equal 2, adventure.current_room.items.size
    assert_equal "a ladder", adventure.current_room.items.first.name
    assert_equal "shopping mall", adventure.current_room.items.first.room
  end
  
end