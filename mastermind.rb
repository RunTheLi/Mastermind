module Boardgame
  class Table
    attr_reader :rows, :columns, :grid

    def initialize(rows = 6, columns = 4)
      @rows = rows
      @columns = columns
      @grid = Array.new(rows) { Array.new(columns, '_') }
      @secret_code = Array.new(columns) { COLORS.sample }
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

    def Human_Choice
      Array.new(columns) { COLORS.sample }
    end
  end
end
