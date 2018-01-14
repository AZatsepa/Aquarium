require './fish.rb'

class Pike < Fish
  NAME = 'Щ'.freeze
  attr_reader :name
  attr_accessor :count_steps
  
  def initialize
    super
    @name   = NAME
    @weight = 3
  end

  def step
    self.count_steps += 1
    weight_change
  end

  def weight_change
    @weight -= 0.5
  end

  def eat_crucian
    @weight += 1
  end
end
