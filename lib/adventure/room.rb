class Adventure
  class Room
  
    attr_reader :name, :description, :paths, :items
  
    def initialize(name, options={})
      @name = name
      @description = options[:description]
      @paths = {
        :north => options[:north],
        :south => options[:south],
        :east => options[:east],
        :west => options[:west]
      }
      @items = []
    end
    
    def add_item(*args)
      @items << Item.new(*args)
    end
  
    def north
      paths[:north]
    end
    
    def south
      paths[:south]
    end
    
    def east
      paths[:east]
    end
    
    def west
      paths[:west]
    end
    
    def look_at(item_name)
      if item = find_item(item_name)
        item.description 
      end
    end
    
    def take(item_name)
      if item = find_item(item_name)
        items.delete(item) if item.takeable?
      end
    end
    
    def drop(item)
      items << item
    end
        
    def user_output
      output = description + "\n\n"
      
      unless items.empty?
        output << "You can see "
        output << items[0..-2].collect{ |item| item.name }.join(', ')
        if items.size > 1
          output << " and #{items[-1].name}"
        else
          output << "#{items[0].name}"
        end
        output << "."
      end
      
      paths.each do |k, v|
        output << "Go #{k} to #{v}\n" if v
      end
      output
    end
    
    private
    
    def find_item(item_name)
      items.find{ |item| item.name =~ /#{item_name}$/ }
    end
  end
end