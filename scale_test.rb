require "bundler/inline"

gemfile(true) do
    source "https://rubygems.org"
    gem "minitest"
end

require 'minitest/autorun'
require_relative "guitar_tool"
require_relative "scale"
require_relative "scale_builder"

class ScaleTest < Minitest::Test
  def test_notes
    self.extend(ScaleBuilder)
    define_scale_from_intervals "Major", [2,2,1,2,2,2,1]
    assert_equal %w(c d e f g a b c), MajorScale.new("c").notes
  end
end
