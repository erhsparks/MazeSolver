#!/usr/bin/env ruby

class MazeSolver
  attr_reader :maze, :all_visited_places, :current_positions, :pathhh

  def initialize(maze = "maze1.txt")
    @maze = File.readlines(maze)
    @maze.map! { |line| line.strip.chars }


  end

  def run
    source, target = find_char("S"), find_char("E")
    @current_positions = [source]
    @all_visited_places = { source => nil }

    explore until @current_positions.empty? ||
                        @all_visited_places.key?(target)

    @pathhh = build_path(target)
    @maze.each {|row| puts row.join('')}
  end

  def build_path(target)
    return [target] if @all_visited_places[target].nil?

    prev_pos = @all_visited_places[target]
    self[target] = "X" unless self[target] == "E"
    path = [target]

    path.concat(build_path(prev_pos))
  end

  def explore
    new_current_positions = []

    @current_positions.each do |current_pos|
      adjacent_positions(current_pos).each do |adj_pos|
        unless @all_visited_places.include?(adj_pos)
          new_current_positions << adj_pos
          @all_visited_places[adj_pos] = current_pos
        end
      end
    end

    @current_positions = new_current_positions
  end

  def adjacent_positions(position)
    row, col = position

    adj = [[row + 1, col], [row - 1, col],
            [row, col + 1], [row, col - 1]]

    adj.select { |pos| self[pos] != "*" }
  end


  def find_char(string)
    position = []

    @maze.each_with_index do |row, row_index|
      col_index = row.index(string)
      next if col_index.nil?

      position = [row_index, col_index]
    end

    position
  end

  def [](pos)
    row, col = pos
    @maze[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @maze[row][col] = value
  end
end


if __FILE__ == $PROGRAM_NAME
  MazeSolver.new.run
end
