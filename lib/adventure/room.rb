class Adventure
  class Room
  
    attr_reader :name, :description, :paths
  
    def initialize(name, options={})
      @name = name
      @description = options[:description]
      @paths = {
        :north => options[:north],
        :south => options[:south],
        :east => options[:east],
        :west => options[:west]
      }
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
  end
end