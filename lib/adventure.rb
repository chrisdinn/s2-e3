require 'yaml'

require 'adventure/room'
require 'adventure/item'

class Adventure
  
  attr_accessor :title, :greeting

  attr_reader :rooms, :current_room, :inventory
  
  def initialize
    @rooms = []
    @inventory = []
  end
  
  class << self
    
    def from_file(file)
      raw_adventure = YAML.load_file(file)
      adventure = new
    
      adventure.title = raw_adventure["title"]
      adventure.greeting = raw_adventure["greeting"]
    
      items = raw_adventure["items"].collect do |raw_item|
        Item.new raw_item.delete("name"), symbolize_keys(raw_item)
      end
      
      raw_adventure["rooms"].each do |raw_room| 
        room = adventure.add_room  raw_room.delete("name"), 
                            :description => raw_room["description"],
                            :north => raw_room["paths"]["north"],
                            :south => raw_room["paths"]["south"],
                            :east => raw_room["paths"]["east"],
                            :west => raw_room["paths"]["west"]
        
        if raw_room["items"]  
          raw_room["items"].each do |item_name| 
             room.items << items.find{ |item| item.named?(item_name)  }
          end
        end
      end
      
      adventure
    end
    
    private
    
    def symbolize_keys(hash)
      hash.each_key{ |key| hash[key.to_sym] = hash.delete(key) }
    end
    
  end
  
  def add_room(*args)
    room = Room.new(*args)
    @current_room = room unless current_room
    @rooms << room
    room
  end
  
  def introduction
    intro = title + "\n\n"
    intro << greeting << "\n\n"
    intro << current_room.user_output << "\n"
  end
  
  def command(text)
    response = "\n"

    case text
    when verb_is('go')
      go $1
      response << current_room.user_output
    when verb_is('look at')
      response << current_room.look_at($1) << "\n"
    when verb_is('look')
      if $1.empty?
        response << current_room.user_output
      else
        response << current_room.look_at($1) << "\n"
      end
    when verb_is('pick up'), verb_is('take')
      response << take($1)
    when verb_is('drop')
      response << drop($1)
    when verb_is('use')
      response << use($1)
    when verb_is('help')
      response << help
    else
      response << ["what?", "huh?", "don't understand that"][rand(3)] << "\n"
    end
    
    response << "\n"
  end
  
  def go(direction)
    new_room = rooms.find do |room|
      current_room.paths[direction.to_sym] == room.name
    end
    @current_room = new_room if new_room
  end
  
  private
  
  def verb_is(verb)
    /^\s*#{verb}\s*(.*)$/
  end
  
  def take(item_name)
    item = current_room.take(item_name)
    if item
      inventory << item
      "Picked up #{item.name}\n"
    else
      "You can't see that.\n"
    end
  end
  
  def use(item_name)
    if item = inventory.find{ |item| item.named?(item_name) }
      item.use(current_room).to_s
    else
      "You don't have #{item_name}."
    end
  end
  
  def drop(item_name)
    if item = inventory.find{ |item| item.named?(item_name) }
      current_room.drop inventory.delete(item)
      "Dropped #{item.name}.\n"
    else
      "Sadly, you can't drop what you don't have.\n"
    end
  end
  
  def help
    %{You can do all sorts of things. Try:
      
  - "look"
  - "go <direction>"
  - "look at <item>"
  - "pick up <item>"
  - "use <item>"
    }
  end
end