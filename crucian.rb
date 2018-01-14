require './fish.rb'
class Crucian < Fish
  NAME = 'K'.freeze
  attr_reader :name

  def initialize
    super
    @name = NAME
  end

  def weight_change
    @weight += 0.5 if (age % 3).zero?
  end
end
