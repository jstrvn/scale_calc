class GuitarTool
  CHROMATIC_SCALE = %w(c c# d d# e f f# g g# a a# b)
  DEFAULT_TUNNING = %w(e a d g b e)

  def initialize(frets, tunning = nil)
    @tunning = tunning
    @frets = frets
  end

  def tunning
    @tunning || DEFAULT_TUNNING
  end

  def frets_list_for_scale(notes_scale, string: nil, strings: nil, lower_fret: nil, upper_fret: nil)
    ii = notes_to_frets(notes_scale, string:, strings:)
    ii.map do |s|
      s.select do 
        _1.dig(:fret) >= lower_fret && _1.dig(:fret) <= upper_fret && _1.dig(:fret) < (lower_fret + (_1.dig(:string) == 3 ? 4 : 5))
      end.map do 
        _1.dig(:fret)
      end
    end
  end


  def notes_to_frets(notes_scale, string: nil, strings: nil)
    return notes_for_string(notes_scale, tunning[string]) unless string.nil?
    
    raise "strings param should have a mark for each string" if !strings.nil? && strings.size != tunning.size
    chosen_strings = if strings.nil? then tunning else decode_strings(strings) end

    frets_for_scale = []
    chosen_strings.each_with_index do |s, i|
      frets_for_scale << notes_for_string(notes_scale, s, i)
    end
    frets_for_scale
  end

  private

  def decode_strings(active_strings) 
    chosen_strings = []
    active_strings.each_with_index do |s, i|
      next if s == "x"
      chosen_strings << tunning[i]
    end
    chosen_strings
  end

  def notes_for_string(notes_scale, string, i = nil)
    starting_pos = CHROMATIC_SCALE.index(string)
    notes = []
    @frets.times do |f|
      if notes_scale.include?(CHROMATIC_SCALE[(starting_pos+f)%12])
        h = {note: CHROMATIC_SCALE[(starting_pos+f)%12], fret: f}
        h.merge!(string: i) unless i.nil?
        notes << h
      end
    end
    notes
  end
end