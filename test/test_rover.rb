require 'test/unit'
require 'shoulda'
require_relative '../lib/scan_plateau/rover'

class TestPlateau < Test::Unit::TestCase

    DEFAULT_ROVER = {
      :x          => 0,
      :y          => 0,
      :direction  => :north
    }

  context "initialization" do
    should "create default rover" do
      rover = ScanPlateau::Rover.new
      assert_equal DEFAULT_ROVER, rover.current_state
    end
  end

  context "update limits" do
    UPDATED_ROVER = {
      :x          => 4,
      :y          => 7,
      :direction  => :west
    }
    should "update rover with good input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '10 10'

      rover = ScanPlateau::Rover.new

      rover.update_current_state('4 7 W', plateau)
      assert_equal UPDATED_ROVER, rover.current_state

      rover.update_current_state(' 4   7  w  ', plateau)
      assert_equal UPDATED_ROVER, rover.current_state
    end
    should "not update rover with bad input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '10 10'

      rover = ScanPlateau::Rover.new

      rover.update_current_state(nil, plateau)
      assert_equal DEFAULT_ROVER, rover.current_state

      rover.update_current_state('', plateau)
      assert_equal DEFAULT_ROVER, rover.current_state

      rover.update_current_state(' 4   7  R  ', plateau)
      assert_equal DEFAULT_ROVER, rover.current_state

      rover.update_current_state(' 4 -7  w  ', plateau)
      assert_equal DEFAULT_ROVER, rover.current_state

      rover.update_current_state('11 5 W', plateau)
      assert_equal DEFAULT_ROVER, rover.current_state
    end
  end

  context "move rover commands" do
    should "update rover position with good input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '5 5'

      rover = ScanPlateau::Rover.new

      rover.update_current_state('1 2 N', plateau)
      rover.follow_commands('LMLMLMLMM', plateau)
      assert_equal '1 3 N', rover.formatted_current_state
     
      rover.update_current_state('3 3 E', plateau)
      rover.follow_commands('MMRMMRMRRM', plateau)
      assert_equal '5 1 E', rover.formatted_current_state

      rover.update_current_state('1 2 N', plateau)
      rover.follow_commands(' lmlml  mlmm  ', plateau)
      assert_equal '1 3 N', rover.formatted_current_state
     
      rover.update_current_state('3 3 E', plateau)
      rover.follow_commands(' m m r m m r m r r M ', plateau)
      assert_equal '5 1 E', rover.formatted_current_state
    end
    should "not update rover position with bad input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '5 5'

      rover = ScanPlateau::Rover.new

      rover.update_current_state('1 2 N', plateau)
      rover.follow_commands(nil, plateau)
      assert_equal '1 2 N', rover.formatted_current_state
     
      rover.update_current_state('3 3 E', plateau)
      rover.follow_commands('  ', plateau)
      assert_equal '3 3 E', rover.formatted_current_state

      rover.update_current_state('1 2 N', plateau)
      rover.follow_commands(' lmlxyml  mlmm  ', plateau)
      assert_equal '1 2 N', rover.formatted_current_state
     
      rover.update_current_state('3 3 E', plateau)
      rover.follow_commands(' m E W m m r m r r M ', plateau)
      assert_equal '3 3 E', rover.formatted_current_state
    end
  end
  
end