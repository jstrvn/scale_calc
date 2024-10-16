require_relative "scale_builder"
require_relative "scale"

self.extend(ScaleBuilder)
define_scale_from_intervals "Major", [2,2,1,2,2,2,1]
define_scale_from_intervals "Minor",[2,1,2,2,1,2,2]
define_scale_from_intervals "HarmonicMinor", [2,1,2,2,1,3,1]
define_scale_from_intervals "Augmented", [3,1,3,1,3,1]
define_scale_from_intervals "WholeTone", [2,2,2,2,2,2]
define_scale_from_intervals "HungarianMajor", [3,1,2,1,2,1,2]
define_scale_from_intervals "SpanishEightTones", [1,2,1,1,1,2,2,2]
define_scale_from_example "PentatonicMinor", %w(e g a b d)
define_scale_from_example "PentatonicMajor", %w(e g# a# b c#)
define_scale_from_example "SpanishPhrygian", %w(a a# c# d e f g)
define_scale_from_example "Phrygian", %w(a a# c d e f g)
define_scale_from_example "BluesMajor", %w(c d d# e g a)
define_scale_from_example "BluesMinor", %w(c d# f f# g a#)
define_scale_from_example "Diminished", %w(c d d# f f# g# a b)
define_scale_from_example "SuspendedPentatonic", %w(c d f g a#)
define_scale_from_example "Sakura", %w(c c# f g g#)
define_scale_from_example "Insen", %w(d d# g a c)
define_scale_from_example "Iwato", %w(c c# f f# a#)
define_scale_from_example "Japanese", %w(a b c e f)
define_scale_from_example "Yo", %w(d e g a b)


def all_scales
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
    flags
end