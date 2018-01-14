require './crucian.rb'
require './pike.rb'
require 'yaml'

class Aquarium
  attr_accessor :reservoir,
                :vertical_size,
                :horizontal_size,
                :field_size,
                :start_crucians_quantity,
                :start_pikes_quantity

  def initialize
    config                   = YAML.load_file('config.yaml')
    @vertical_size           = config['vertical_size']
    @horizontal_size         = config['horizontal_size']
    @start_crucians_quantity = config['crucians_quantity']
    @start_pikes_quantity    = config['pikes_quantity']
    @field_size = vertical_size * horizontal_size
    @reservoir =  Array.new(field_size).map! { [] }
    fish_run
  end

  def print_aquarium(reservoir = @reservoir)
    (horizontal_size + 2).times { print '=' }
    print "\n"
    count_start = 0
    count_end = horizontal_size
    while count_end <= @field_size
      print '|'
      reservoir[count_start...count_end].each do |elem|
        if elem == []
          print ' '
        elsif elem.size > 1
          print '*'
        else
          print elem[0].name
        end
      end
      puts "|\n"
      count_start += horizontal_size
      count_end += horizontal_size
    end
    (horizontal_size + 2).times { print '=' }
    print "\n"
  end

  def fish_run
    start_pikes_quantity.times { add_pike }
    start_crucians_quantity.times { add_crucian }
  end

  def add_pike
    @reservoir[rand(0...field_size)] << Pike.new
  end

  def add_crucian
    @reservoir[rand(0...field_size)] << Crucian.new
  end

  def stroke
    result = Array.new(field_size).map! { [] }
    reservoir.each_with_index do |elem, index|
      elem.delete_if { |fish| fish.weight.zero? }
      if elem.size >= 2
        eat! elem
        reproduce elem
      end
      steps elem, index, result
    end
      @reservoir = result
      nil
  end

  def randomizer(index)
    size = vertical_size * horizontal_size
    res = (0...size).each_with_object([]) { |i, a| a << i }
    array = []
    count_start  = 0
    count_finish = @horizontal_size - 1
    vertical_size.times do
      array << res[count_start..count_finish]
      count_start += horizontal_size
      count_finish += horizontal_size
    end
    output = []
    array.each_with_index do |elem, i|
      output << i if elem.include? index
    end
    array[output[0]].each_with_index do |elem2, i2|
      output << i2 if elem2 == index
    end
    index_one = output[0]
    index_two = output[1]
    result = []
    result << array[index_one - 1][index_two - 1] if index_one > 0 && index_two > 0
    result << array[index_one - 1][index_two]     if index_one > 0
    result << array[index_one - 1][index_two + 1] if index_one > 0
    result << array[index_one][index_two - 1]     if index_two > 0
    result << array[index_one][index_two + 1]     if index_two != horizontal_size - 1
    result << array[index_one + 1][index_two - 1] if index_one != vertical_size - 1 && index_two > 0
    result << array[index_one + 1][index_two]     if index_one != vertical_size - 1
    result << array[index_one + 1][index_two + 1] if index_one != vertical_size - 1
    result.compact.sample
  end

  def steps(elem, index, result)
    elem.each do |fish|
      random = randomizer index
      fish.age += 1
      fish.weight_change
      result[random] << fish
      elem.delete fish
    end
  end

  def eat!(elem)
    pike    = elem.find { |fish| fish.class == Pike }
    crucian = elem.find { |fish| fish.class == Crucian }
    if crucian.nil? && pike.nil?
      pike.weight += crucian.weight
      crucian.weight = 0
      elem.delete_if { |fish| fish.weight.zero? }
    end
    elem
  end

  def pikes
    @reservoir.flatten.count { |fish| fish.class == Pike }
  end

  def crucians
    @reservoir.flatten.count { |fish| fish.class == Crucian }
  end

  def reproduce(elem)
    crucian_male   = []
    crucian_female = []
    pike_male      = []
    pike_female    = []
    elem.each do |fish|
      if fish.class == Crucian && fish.gender == :male && fish.age >= 3
        crucian_male << fish
      end
      if fish.class == Crucian && fish.gender == :female && fish.age >= 3
        crucian_female << fish
      end
      if fish.class == Pike && fish.gender == :male && fish.age >= 3
        pike_male << fish
      end
      if fish.class == Pike && fish.gender == :female && fish.age >= 3
        pike_female << fish
      end
    end

    elem << Crucian.new if crucian_male != 0 && crucian_female != 0
    elem << Pike.new if pike_male != 0 && pike_female != 0
    nil
  end
end
