class Adventure
  class Item
    attr_reader :name, :description, :fixed_position
    
    def initialize(name, options={})
      @name = name
      @description = options[:description]
      @fixed_position = options[:fixed_position]
    end
    
    def takeable?
      !fixed_position
    end
  end
end