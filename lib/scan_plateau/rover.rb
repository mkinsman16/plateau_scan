require_relative '../scan_plateau/plateau'

module ScanPlateau
  class Rover

      DIR_MAP = {
        'N' => :north,
        'E' => :east,
        'S' => :south,
        'W' => :west
      }

      COMMAND_MAP = {
        'M' => :move,
        'L' => :left,
        'R' => :right
      }

      DIR_CHANGE_ARRAY = [
        :north,
        :east,
        :south,
        :west
      ]

      # for unit test access
      attr_reader :current_state

      def initialize
        @current_state = {
          :x          => 0,
          :y          => 0,
          :direction  => :north
        }
      end

      def update_current_state(input_string, plateau)
        @current_state.merge! get_state_updates(input_string, plateau)
      end

      def follow_commands(input_string, plateau)
        get_commands(input_string).each {|command|
          if command == :move
            new_destination = calculate_destination 
            @current_state.merge!(new_destination) if plateau.valid_destination?(new_destination)
          else
            @current_state[:direction] = calculate_direction command
          end
        }
      end

      def formatted_current_state
        "#{@current_state[:x]} #{@current_state[:y]} #{DIR_MAP.rassoc(@current_state[:direction])[0]}"
      end

    private

      def get_state_updates(input_string, plateau)
        return {} unless valid_state_input? input_string
        parsed_state_change = input_string.strip.split(' ')
        state_updates = generate_state_update_array parsed_state_change
        return {} unless plateau.valid_destination?(state_updates)
        state_updates
      end

      def valid_state_input?(input_string)
        return !input_string.nil? && input_string.upcase.match(/\A\s*[0-9]+\s+[0-9]+\s+[NESW]\s*\Z/)
      end

      def generate_state_update_array(parsed_state_change)
        limit_updates = {}
        limit_updates[:x] = parsed_state_change[0].to_i
        limit_updates[:y] = parsed_state_change[1].to_i
        limit_updates[:direction] = DIR_MAP[parsed_state_change[2].upcase]
        limit_updates
      end

      def get_commands(input_string)
        return {} unless valid_command_input? input_string
        input_string.delete(' ').upcase.split('').collect! {|command| COMMAND_MAP[command]}
      end

      def valid_command_input?(input_string)
        return !input_string.nil? && input_string.upcase.match(/\A[ MLR]+\Z/)
      end

      def calculate_destination
        new_destination = {
          :x => @current_state[:x],
          :y => @current_state[:y]
        }

        case @current_state[:direction]
        when :north
          new_destination[:y] += 1
        when :east
          new_destination[:x] += 1
        when :south
          new_destination[:y] -= 1
        when :west
          new_destination[:x] -= 1
        end
        new_destination
      end

      def calculate_direction(command)
        current_index = DIR_CHANGE_ARRAY.find_index(@current_state[:direction])
        if command == :left
          new_index = current_index == 0 ? DIR_CHANGE_ARRAY.length - 1 : current_index - 1
          DIR_CHANGE_ARRAY[new_index]
        else
          new_index = current_index == DIR_CHANGE_ARRAY.length - 1 ? 0 : current_index + 1
          DIR_CHANGE_ARRAY[new_index]
        end
      end

  end
end
