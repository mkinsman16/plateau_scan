module ScanPlateau
  class Plateau

      # for unit test access
      attr_reader :plateau_limits

      def initialize
        @plateau_limits = {
          :x  => (0..0),
          :y  => (0..0)
        }
      end

      def plateau_limits=(raw_limits)
        @plateau_limits.merge! get_limit_updates(raw_limits)
      end
      
      def valid_destination?(new_destination)
        return @plateau_limits[:x].include?(new_destination[:x]) &&
          @plateau_limits[:y].include?(new_destination[:y])
      end

    private

      def get_limit_updates(raw_limits)
        return {} unless valid_limits_input? raw_limits
        parsed_limits = raw_limits.strip.split(' ')
        generate_limit_update_array parsed_limits
      end

      def valid_limits_input?(raw_limits)
        return !raw_limits.nil? && raw_limits.match(/\A\s*[0-9]+\s+[0-9]+\s*\Z/)
      end

      def generate_limit_update_array(parsed_limits)
        limit_updates = {}
        limit_updates[:x] = (0..parsed_limits[0].to_i)
        limit_updates[:y] = (0..parsed_limits[1].to_i)
        limit_updates
      end

  end
end
    