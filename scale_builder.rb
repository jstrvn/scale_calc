module ScaleBuilder
  def define_scale_from_example(name, example)
    eval <<-TERMINATOR
    class ::#{name}Scale < Scale
      def initialize(note)
        super(note, infer_formula(#{example}))
      end
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
    end
  TERMINATOR
  end
  
  def define_scale_from_intervals(name, intervals)
    eval <<-TERMINATOR
      class ::#{name}Scale < Scale
        def initialize(note)
        super(note, #{intervals})
      end
    end
    TERMINATOR
  end
end