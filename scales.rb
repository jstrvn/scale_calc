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
define_scale_from_example "Blues", %w(e g a a# b d)
define_scale_from_example "SuspendedPentatonic", %w(c d f g a#)
define_scale_from_example "Sakura", %w(c c# f g g#)
define_scale_from_intervals "Insen", %w(d d# g a c)
define_scale_from_intervals "Iwato", %w(c c# f f# a#)

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