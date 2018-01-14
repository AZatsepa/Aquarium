require './aquarium.rb'

aq = Aquarium.new
while aq.pikes && aq.crucians
  aq.print_aquarium
  aq.stroke
  sleep 1
end
