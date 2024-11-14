require 'minitest/autorun'
require_relative "guitar_tool"

class GuitarToolTest < Minitest::Test
  def test_notes_to_frets_first_string
    g = GuitarTool.new(19)
    n = g.notes_to_frets(%w(c d e f g a b), string: 0)
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.map{|e| e[:fret]}
  end

  def test_notes_to_frets_no_specifying_string
    g = GuitarTool.new(19, %w(e a d g b e))
    n = g.notes_to_frets(%w(c d e f g a b))
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.first.map{|e| e[:fret]}
  end

  def test_notes_to_frets_arbitrary_string
    g = GuitarTool.new(19, %w(e a d g b e))
    n = g.notes_to_frets(%w(c d e f g a b), strings: %w(x o x x x x))
    assert_equal [0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17], n.first.map{|e| e[:fret]}
  end

  def test_bounds_for_frets_lists_root_position
    g = GuitarTool.new(19, %w(e a d g b e))
    fr = g.frets_list_for_scale(%w(c d e f g a b), strings: %w(o o o o o o), lower_fret: 0, upper_fret: 4)
    assert_equal [[0, 1, 3], [0, 2, 3], [0, 2, 3], [0, 2], [0, 1, 3], [0, 1, 3]], fr
  end

  def test_bounds_for_frets_lists_seven_position
    g = GuitarTool.new(19, %w(e a d g b e))
    fr = g.frets_list_for_scale(%w(c d e f g a b), strings: %w(o o o o o o), lower_fret: 7, upper_fret: 10)
    assert_equal [[7, 8, 10], [7, 8, 10], [7, 9, 10], [7, 9, 10], [8, 10], [7, 8, 10]], fr
  end
end
