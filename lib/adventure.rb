require 'yaml'

require 'adventure/room'
require 'adventure/item'

class Adventure
  
  attr_reader :rooms, :current_room
  
  def initialize
    @rooms = []
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
    when /^\s*go\s+(.+)/
      go $1.to_sym
      response << current_room.user_output
    when /^\s*look at\s*(.+)$/
      response << current_room.look_at($1)
    when /^\s*look\s*$/
      response << current_room.user_output
    else
      response << ["what?", "huh?", "don't understand that"][rand(3)] << "\n"
    end
    
    response << "\n"
  end
  
end