require "minitest/autorun"
require_relative 'game_of_life'

class TestGameOfLife < Minitest::Test
  ALIVE_VALUE = GameOfLife::ALIVE_VALUE
  DEAD_VALUE = GameOfLife::DEAD_VALUE
  
  def setup
    # Note tests will fail if subsequent grids have differing dimensions
    @grid = [
      [0, 0, 0, 0, 1],
      [0, 1, 0, 0, 1],
      [1, 0, 0, 0, 1],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 1]
    ]
    @application =  GameOfLife.new(@grid)
  end

  def test_alive?
    # Any live cell with fewer than two live neighbors dies, as if by underpopulation.
    assert_equal(DEAD_VALUE, @application.alive?(ALIVE_VALUE, 1))
    assert_equal(DEAD_VALUE, @application.alive?(ALIVE_VALUE, 0))
    # Any live cell with two or three live neighbors lives on to the next generation.
    assert_equal(ALIVE_VALUE, @application.alive?(ALIVE_VALUE, 2))
    assert_equal(ALIVE_VALUE, @application.alive?(ALIVE_VALUE, 3))
    # Any live cell with more than three live neighbors dies, as if by overpopulation.
    assert_equal(DEAD_VALUE, @application.alive?(ALIVE_VALUE, 4))
    assert_equal(DEAD_VALUE, @application.alive?(ALIVE_VALUE, 5))
    # # Any dead cell with exactly three live neighbors becomes a live cell, as if by reproduction.
    assert_equal(ALIVE_VALUE, @application.alive?(DEAD_VALUE, 3))
    #
    # # Implied
    assert_equal(DEAD_VALUE, @application.alive?(DEAD_VALUE, 2))
    assert_equal(DEAD_VALUE, @application.alive?(DEAD_VALUE, 5))
  end

  def test_num_alive_neighbors
    # Two down, 1 right
    expected = 3
    assert_equal(expected , @application.num_alive_neighbors(2, 1, @grid))
    # Bottom left
    expected = 0
    assert_equal(expected , @application.num_alive_neighbors(4, 0, @grid))

    # Top right
    expected = 1
    assert_equal(expected , @application.num_alive_neighbors(0, 4, @grid))
  end

  def test_generate_new_grid
    blinker = [
      [0, 0, 0, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0]
    ]
    expected = [
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0],
      [0, 1, 1, 1, 0],
      [0, 0, 0, 0, 0],
      [0, 0, 0, 0, 0]
    ]
    assert_equal(expected, @application.generate_new_grid(blinker))

    boat = [
      [0, 0, 0, 0, 0],
      [0, 1, 1, 0, 0],
      [0, 1, 0, 1, 0],
      [0, 0, 1, 0, 0],
      [0, 0, 0, 0, 0]
    ]
    expected = boat
    assert_equal(expected, @application.generate_new_grid(boat))
  end


end