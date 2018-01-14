class Fish
  attr_accessor :weight, :count_steps, :age
  attr_reader :gender
  GENDER = %i[male female].freeze

  def initialize
    @age         = 1
    @weight      = 1
    @count_steps = 0
    @gender      = GENDER.sample
  end
end
