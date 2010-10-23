require 'adventure/room'

class Adventure
  
  attr_reader :rooms, :current_room
  
  def initialize
    @rooms = []
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
    if text.match /^go (.+)/
      go $1.to_sym
      current_room.description
    end
  end
  
end