require 'yaml'

require 'adventure/room'

class Adventure
  
  attr_reader :rooms, :current_room
  
  def initialize
    @rooms = []
  end
  
  def self.from_file(file)
    raw_adventure = YAML.load_file(file)
    adventure = new
    raw_adventure["rooms"].each do |room|      
      adventure.add_room  room.delete("name").to_sym,
                          :description => room["description"],
                          :north => room["paths"]["north"] ? room["paths"]["north"].to_sym : nil,
                          :south => room["paths"]["south"] ? room["paths"]["south"].to_sym : nil,
                          :east => room["paths"]["east"] ? room["paths"]["east"].to_sym : nil,
                          :west => room["paths"]["west"] ? room["paths"]["west"].to_sym : nil
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
    when /^\s*look\s*$/
      response << current_room.user_output
    else
      response << ["what?", "huh?", "don't understand that"][rand(3)] << "\n"
    end
    
    response << "\n"
  end
  
end