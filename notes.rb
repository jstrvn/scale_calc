#!/usr/bin/env ruby
class InvalidKeyError < StandardError; end
class InvalidScaleError < StandardError; end
class InvalidIntervalError < StandardError; end

class Scale
  def self.inherited(subclass)
    @descendants ||= []
    @descendants << subclass
  end

  def self.descendants = @descendants

  CHROMATIC_SCALE = %w(c c# d d# e f f# g g# a a# b)
  def CHROMATIC_SCALE.[](index)
    super(index%12)
  end

  def self.circle(initial_note, interval)
    nodes = {}
    CHROMATIC_SCALE.each_with_index do |x, i|
      nodes[x] = CHROMATIC_SCALE[i+interval]
    end
    current_key = initial_note
    visited_keys = {}
    path = []

    loop do
      break unless visited_keys[current_key].nil?
      path << current_key
      visited_keys[current_key] = 1
      current_key = nodes[current_key]
    end
    path
  end
  
  def initialize(initial_note, formula)
    @initial_note = initial_note
    @formula = formula
  end
  
  def notes
    @notes ||= begin 
      i = CHROMATIC_SCALE.index(@initial_note)
      if i.nil?
        return
      end
      n = [@initial_note]
      formula = @formula.dup
      loop do
        current_interval = formula.shift
        break if current_interval.nil?
        i += current_interval
        n << CHROMATIC_SCALE[i%12]
      end
      n
    end
  end

  def chords(*degrees, triads: false)
    degrees = [1,2,3,4,5,6,7] if degrees.empty?
    formulas = [
        [4,3],
        [3,4],
        [4,4],
        [3,3],
        [3,3,3],#dim 7
        [3,3,4],#h dim 7
        [3,4,3],
        [3,4,4],
        [4,2,4],
        [4,3,3],
        [4,3,4],
        [4,4,3]
    ]
    formulas.select!{_1.size == 2} if triads == true

    degrees.map do |degree|
      ch = []
      i = degree-1
      formulas.each do |f|
        next unless self.notes[i]
        p = CHROMATIC_SCALE.index(self.notes[i])
        c = []
        ff = f.dup
        until ff.empty?
          p += ff.shift
          c << CHROMATIC_SCALE[p]
        end
        if c.difference(self.notes).empty?
          ch << [self.notes[i], *c]
        end
      end
      ch
    end.flatten(1)
  end
end

CHROMATIC_SCALE = %w(c c# d d# e f f# g g# a a# b)

def infer_formula(notes)
  formula = []
  s = CHROMATIC_SCALE.index(notes.shift)
  p = s
  loop do
    n = CHROMATIC_SCALE.index(notes.shift)
    if !n.nil? && n < p 
      n -= 12
    end
    break if n.nil?
    formula << n-s
    s = n
  end
  formula
end

def define_scale_from_example(name, example)
  eval <<-TERMINATOR
    class #{name}Scale < Scale
      def initialize(note)
        super(note, infer_formula(#{example}))
      end
    end
  TERMINATOR
end

def define_scale_from_intervals(name, intervals)
  eval <<-TERMINATOR
    class #{name}Scale < Scale
      def initialize(note)
        super(note, #{intervals})
      end
    end
  TERMINATOR
end

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

if $PROGRAM_NAME == __FILE__
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