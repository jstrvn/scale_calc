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
    degrees = begin 
      if degrees.empty?
        [1,2,3,4,5,6,7]
      else
        map_to_romans = {
          "i": 1,
          "ii": 2,
          "iii": 3,
          "iv": 4,
          "v": 5,
          "vi": 6,
          "vii": 7
        }
        degrees.map{map_to_romans[_1.to_sym]}.compact
      end
    end
    
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
