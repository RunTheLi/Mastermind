module Boardgame
  class Table
    attr_reader :rows, :columns, :grid

    COLORS = %w[Red Blue Green Yellow White Black].freeze

    def initialize(rows = 6, columns = 4, player_creates = false)
      @rows = rows
      @columns = columns
      @grid = Array.new(rows) { Array.new(columns, '_') }
      @player_creates = player_creates
      @secret_code = player_creates ? player_choice : computer_choice
      computer_guess if player_creates
    end

    def display
      @grid.each { |row| puts row.join(' | ') }
    end

    def computer_Choice
      Array.new(columns) { COLORS.sample }
    end

    def feedback(guess)
      exact_matches = guess.zip(@secret_code).count { |g, s| g == s }
      color_matches = (guess & @secret_code).sum do |color|
        [guess.count(color), @secret_code.count(color)].min
      end - exact_matches
      { exact: exact_matches, color: color_matches }
    end

    def player_choice
      puts "Enter your secret code #{@columns} colors, seperated by space"
      gets.chomp.split.map(&:capitalize)
    end

    def computer_guess
      guess = Array.new(columns) { COLORS.sample }
      attempt = 0
      known_positions = Array.new(columns, nil) # To track known correct positions
      known_colors = []
      loop do
        attempt += 1
        feedback_result = feedback(guess)
        puts "Computer guesses: #{guess.join(', ')} | Feedback: #{feedback_result}"

        # If exact matches equal the number of columns, break
        if feedback_result[:exact] == @columns
          puts "Computer guessed the secret code in #{attempt} attempts!"
          break
        end

        guess.each_with_index do |color, index|
          if color == @secret_code[index]
            known_positions[index] = color
          elsif @secret_code.include?(color) && !known_colors.include?(color)
            known_colors << color
          end
        end

        guess = known_positions.map.with_index do |c, i|
          c || (known_colors.include?(guess[i]) ? guess[i] : COLORS.sample)
        end
      end
      puts "Computer guessed the secret code in #{attempts} attempts!"
    end
  end
end

game = Boardgame::Table.new(6, 4, true)
game.display
game.computer_guess
