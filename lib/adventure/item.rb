class Adventure
  class Item
    attr_reader :name, :description
    
    def initialize(name, options={})
      @name = name
      @description = options[:description]
    end
  end
end