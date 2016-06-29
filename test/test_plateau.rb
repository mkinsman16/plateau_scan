require 'test/unit'
require 'shoulda'
require_relative '../lib/scan_plateau/plateau'

class TestPlateau < Test::Unit::TestCase

    DEFAULT_PLATEAU = {
      :x  => (0..0),
      :y  => (0..0)
    }

  context "default initialization" do
    should "create default plateau" do
      plateau = ScanPlateau::Plateau.new
      assert_equal DEFAULT_PLATEAU, plateau.plateau_limits
    end
  end

  context "update limits" do
    UPDATED_PLATEAU = {
      :x  => (0..21),
      :y  => (0..17)
    }
    should "update plateau limits with good input" do
      plateau = ScanPlateau::Plateau.new

      plateau.plateau_limits = ' 21   17  '
      assert_equal UPDATED_PLATEAU, plateau.plateau_limits
    end
    should "not update plateau limits with bad input" do
      plateau = ScanPlateau::Plateau.new

      plateau.plateau_limits = nil
      assert_equal DEFAULT_PLATEAU, plateau.plateau_limits

      plateau.plateau_limits = ' '
      assert_equal DEFAULT_PLATEAU, plateau.plateau_limits

      plateau.plateau_limits = ' 21   17  N '
      assert_equal DEFAULT_PLATEAU, plateau.plateau_limits
    end
  end

  context "destination checking" do
    should "pass with good input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '5 5'

      assert_equal true, plateau.valid_destination?({:x => 0, :y => 0})

      assert_equal true, plateau.valid_destination?({:x => 5, :y => 5})
    end
    should "not pass with bad input" do
      plateau = ScanPlateau::Plateau.new
      plateau.plateau_limits = '5 5'

      assert_equal false, plateau.valid_destination?({:x => 6, :y => 0})

      assert_equal false, plateau.valid_destination?({:x => 0, :y => 6})

      assert_equal false, plateau.valid_destination?({:x => -1, :y => 0})

      assert_equal false, plateau.valid_destination?({:x => 0, :y => 'N'})
    end
  end
  
end