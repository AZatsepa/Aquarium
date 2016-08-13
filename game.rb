require './aquarium.rb'

aq = Aquarium.new
while aq.pikes != 0 && aq.crucians != 0
  aq.print_aquarium
  aq.stroke 
  sleep 1
end
