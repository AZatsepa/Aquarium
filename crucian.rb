require "./fish.rb"
class Crucian < Fish
  attr_reader :name

  def initialize
    super
    @name = "К"
  end
  
  def weight_change
    @weight += 0.5 if age % 3 == 0
  end

end
