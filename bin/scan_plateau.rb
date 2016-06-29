require 'scan_plateau/plateau'
require 'scan_plateau/rover'

# To run:  scan_plateau>ruby -I lib bin\scan_plateau.rb
# To exit, enter end-of-file at any prompt (^d or ^z)

print "\nEnter plateau limits:  "
plateau_input = gets
plateau = ScanPlateau::Plateau.new
plateau.plateau_limits = plateau_input

print "\nEnter first rover initial state:  "
while rover_init = gets
  rover = ScanPlateau::Rover.new
  rover.update_current_state(rover_init.chomp, plateau)
  print "Enter rover command string:  "
  break unless (rover_commands = gets)
  rover.follow_commands rover_commands.chomp, plateau
  print "New rover state:  #{rover.formatted_current_state}\n"
  print "\nEnter next rover initial state:  "
end
