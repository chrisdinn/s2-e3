class Adventure
  class Item
    attr_reader :name, :description, :fixed_position, :message, 
                :room, :paths, :required_item, :remove
    
    def initialize(name, options={})
      @name = name
      @description = options[:description]
      @fixed_position = options[:fixed_position]
      @message = options[:message]
      @room = options[:in]
      @paths = options[:paths] || {}
      @required_item = options[:require]
      @remove = options[:remove]
    end
    
    def takeable?
      !fixed_position
    end
    
    def named?(possible_name)
      name =~ /#{possible_name}$/
    end
    
    def use(current_room)
      if room && room!=current_room.name
        "You can't use that here."
      elsif required_item && !current_room.find_item(required_item)
         "Hmm, something's wrong."
      else
        add_paths current_room
        remove_item current_room
        
        message
      end
    end
    
    private
    
    def add_paths(current_room)
      paths.each do |direction, room| 
        current_room.paths[direction] = room
      end
    end
    
    def remove_item(current_room)
      if remove && item = current_room.find_item(remove)
        current_room.items.delete(item)
      end
    end
  end
end