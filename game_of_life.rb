require 'pp'

class GameOfLife
  attr_reader :max_height, :max_width

  def initialize(seed_grid)
    @seed_grid = seed_grid
    @max_height = seed_grid.first.length - 1
    @max_width = seed_grid.length - 1
  end
  ALIVE_VALUE = 1
  DEAD_VALUE = 0
  ALIVE_PIXEL = '■'
  DEAD_PIXEL = '□'

  def alive?(cell_state, num_alive_neighbors)
    if cell_state == ALIVE_VALUE
      if num_alive_neighbors < 2
        return DEAD_VALUE
      end
      if num_alive_neighbors == 2 || num_alive_neighbors == 3
        return ALIVE_VALUE
      end
      if num_alive_neighbors > 3
        return DEAD_VALUE
      end
    else
      if num_alive_neighbors == 3
        return ALIVE_VALUE
      end
    end
    return cell_state
  end

  def num_alive_neighbors(row, col, grid)
    num_alive = 0
    ((row-1) ..(row + 1)).each do |current_row|
      ((col-1) ..(col + 1)).each do |current_col|
        next if current_row == row && current_col == col
        next if current_row < 0 || current_row > max_height
        next if current_col < 0 || current_col > max_width
        if grid[current_row][current_col] == ALIVE_VALUE
          num_alive += 1
        end
      end
    end
    return num_alive
  end

  def generate_new_grid(old_grid)
    new_grid = Array.new(max_height + 1) { Array.new(max_width + 1) }
    old_grid.freeze.each_with_index do |row, row_index|
      row.each_with_index do |cell_state, col_index|
        alive_neighbors = num_alive_neighbors(row_index, col_index, old_grid)
        new_cell_state = alive?(cell_state, alive_neighbors)
        new_grid[row_index][col_index] = new_cell_state
      end
    end
    return new_grid
  end

  def run
    grid = @seed_grid
    loop do
      puts `clear`
      grid = generate_new_grid(grid)
      print_grid(grid)
      sleep(0.5)
    end
  end

  def print_grid(grid)
    rendered_grid = grid.map { |row|
      row.map { |cell|
        if cell == ALIVE_VALUE
          ALIVE_PIXEL
        else
          DEAD_PIXEL
        end
      }.join('')
    }.join("\n")
    puts rendered_grid
  end

end

seed_grid = [
  [0, 0, 0, 0, 0],
  [0, 0, 1, 0, 0],
  [0, 0, 1, 0, 0],
  [0, 0, 1, 0, 0],
  [0, 0, 0, 0, 0]
]

GameOfLife.new(seed_grid).run