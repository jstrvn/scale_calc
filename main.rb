#!/usr/bin/env ruby
require_relative "errors"
require_relative "scale_builder"
require_relative "scale"

if $PROGRAM_NAME == __FILE__
  self.extend(ScaleBuilder)
  define_scale_from_intervals "MajorScale", [2,2,1,2,2,2,1]
  define_scale_from_intervals "MinorScale",[2,1,2,2,1,2,2]
  define_scale_from_intervals "HarmonicMinor", [2,1,2,2,1,3,1]
  define_scale_from_intervals "Augmented", [3,1,3,1,3,1]
  define_scale_from_intervals "WholeTone", [2,2,2,2,2,2]
  define_scale_from_intervals "HungarianMajor", [3,1,2,1,2,1,2]
  define_scale_from_intervals "SpanishEightTones", [1,2,1,1,1,2,2,2]
  define_scale_from_example "PentatonicMinor", %w(e g a b d)
  define_scale_from_example "PentatonicMajor", %w(e g# a# b c#)
  define_scale_from_example "SpanishPhrygian", %w(a a# c# d e f g)
  define_scale_from_example "Phrygian", %w(a a# c d e f g)
  define_scale_from_example "Blues", %w(e g a a# b d)

  p Scale.circle("c", 7) and exit(0) if ARGV[0].nil?
  current_key = ARGV[0].downcase
  #generate flags from class names
  flags = {}
  Scale.descendants.each do |klass|
    name = klass.to_s
    ckey = ""
    loop do
      ckey += name.slice!(0).downcase
      next if flags.has_key?(ckey)
      flags[ckey] = klass
      break
    end
  end
  raise "-- usage <note> <#{flags.keys.join("|")}>" if ARGV[1].nil?
  mode = ARGV[1].downcase
  raise InvalidScaleError, "-- usage <note> <#{flags.keys.join("|")}>" unless flags.has_key?(mode)
  s = flags[mode].new(current_key)
  puts "---scale---"
  puts flags[mode]
  puts "---notes---"
  p s.notes
  puts "---chords---"
  p s.chords(triads: true)
end