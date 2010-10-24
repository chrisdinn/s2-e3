require 'yaml'

require 'adventure/room'
require 'adventure/item'

class Adventure
  
  attr_reader :rooms, :current_room, :inventory
  
  def initialize
    @rooms = []
    @inventory = []
  end
  
  def self.from_file(file)
    raw_adventure = YAML.load_file(file)
    adventure = new
    raw_adventure["rooms"].each do |room|      
      adventure.add_room  room.delete("name"), :description => room["description"],
                          :north => room["paths"]["north"],
                          :south => room["paths"]["south"],
                          :east => room["paths"]["east"],
                          :west => room["paths"]["west"]
    end
  
    adventure
  end
  
  def add_room(*args)
    room = Room.new(*args)
    @current_room = room unless current_room
    @rooms << room
  end
  
  def go(direction)
    new_room = rooms.find do |room|
      current_room.paths[direction] == room.name
    end
    @current_room = new_room if new_room
  end
  
  def command(text)
    response = "\n"

    case text
    when verb_is('go')
      go $1.to_sym
      response << current_room.user_output
    when verb_is('look at')
      response << current_room.look_at($1)
    when verb_is('look')
      response << current_room.user_output
    when verb_is('pick up'), verb_is('take')
      item = current_room.take($1)
      if item
        inventory << item
        response << "Picked up #{item.name}\n"
      else
        response << "I can't see that.\n"
      end
    when verb_is('drop')
      if item = find_inventory_item($1)
        current_room.drop inventory.delete(item)
        response << "Dropped #{item.name}"
      else
        response << "Sadly, you can't drop what you don't have."
      end
    else
      response << ["what?", "huh?", "don't understand that"][rand(3)] << "\n"
    end
    
    response << "\n"
  end
  
  private
  
  def verb_is(verb)
    /^\s*#{verb}\s*(.*)$/
  end
    
  def find_inventory_item(item_name)
    inventory.find{ |item| item.name =~ /#{item_name}$/ }
  end
end