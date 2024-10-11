require "bundler/inline"

gemfile(true) do
    source "https://rubygems.org"
    gem "minitest"
end

require 'minitest/autorun'
require_relative "guitar_tool"
require_relative "scale"
require_relative "scale_builder"

class GuitarToolTest < Minitest::Test
  def test_notes_to_frets_first_string
    g = GuitarTool.new(19)
    n = g.notes_to_frets(%w(c d e f g a b), string: 0)
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.map{|e| e[:fret]}
  end

  def test_notes_to_frets
    g = GuitarTool.new(19, %w(e a d g b e))
    n = g.notes_to_frets(%w(c d e f g a b))
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.first.map{|e| e[:fret]}
  end

  def test_notes_to_frets
    g = GuitarTool.new(19, %w(e a d g b e))
    n = g.notes_to_frets(%w(c d e f g a b), strings: %w(x x x x x o))
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.first.map{|e| e[:fret]}
  end


  def test_notes_from_scale_to_frets
    self.extend(ScaleBuilder)
    define_scale_from_intervals "Major", [2,2,1,2,2,2,1]
    g = GuitarTool.new(19, %w(e a d g b e))
    n = g.notes_to_frets(MajorScale)
    assert_equal [0, 1, 3, 5, 7, 8, 10, 12, 13, 15, 17], n.first.map{|e| e[:fret]}
  end
end
