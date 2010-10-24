require 'test_helper'

class ItemTest < Test::Unit::TestCase
  
  def test_name
    item = Adventure::Item.new "ladder"
    assert_equal "ladder", item.name
  end
  
  def test_description
    description = "An old ladder. Can't support much weight"
    item = Adventure::Item.new "ladder", :description => description
    assert_equal description, item.description
  end
  
  def test_use_with_message
    item = Adventure::Item.new "ladder", :message => "climb climb"
    room = Adventure::Room.new "attic"
    assert_equal "climb climb", item.use(room)
  end
  
  def test_use_only_in_certain_room
    item = Adventure::Item.new "ladder", :in => "attic", :message => "climb climb"
    
    living_room = Adventure::Room.new "living room"
    assert_equal "You can't use that here.", item.use(living_room)
    
    attic = Adventure::Room.new "attic"
    assert_equal "climb climb", item.use(attic)
  end
  
  def test_use_only_in_certain_room
    item = Adventure::Item.new "ladder", :in => "attic", :message => "climb climb"
    
    living_room = Adventure::Room.new "living room"
    assert_equal "You can't use that here.", item.use(living_room)
    
    attic = Adventure::Room.new "attic"
    assert_equal "climb climb", item.use(attic)
  end
  
  def test_use_add_path
    item = Adventure::Item.new  "ladder", 
                                :in => "living room", 
                                :paths => { :north => "attic" },
                                :message => "You place the ladder against the hole in the ceiling."
    
    living_room = Adventure::Room.new "living room"
        
    assert_match /#{item.message}/, item.use(living_room)
    assert_equal "attic", living_room.north 
  end
  
  def test_use_require_item
    item = Adventure::Item.new "ladder", :require => "floor mat", :message => "climb climb"
    
    living_room = Adventure::Room.new "living room"
    assert_equal "Hmm, something's wrong.", item.use(living_room)
    
    living_room.add_item "floor mat"
    assert_equal "climb climb", item.use(living_room)
  end
  
  def test_use_remove_item
    matches = Adventure::Item.new "matches", :remove => "newspaper"
    fire_pit = Adventure::Room.new "fire pit"
    fire_pit.add_item "newspaper"

    matches.use fire_pit
    
    assert fire_pit.items.empty?
  end

end