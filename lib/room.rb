
class Room
  
  attr_reader :name, :description, :north
  
  def initialize(name, options={})
    @name = name
    @description = options[:description]
    
    @north = options[:north]
    @south = options[:south]
    @east = options[:east]
    @west = options[:west]
  end
  
end