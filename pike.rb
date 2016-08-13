require './fish.rb'

class Pike < Fish
  attr_reader :name
  
  def initialize
    super
    @name   = "Щ"
    @weight = 3
  end

  def step 
    count_steps += 1
    weight_change
  end

  def weight_change
    @weight -= 0.5
  end
  
  def eat_crucian
    @weight += 1
  end

end
