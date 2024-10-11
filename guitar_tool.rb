require_relative "scale"

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

    def notes_to_frets(notes_scale, string: nil, strings: nil)
        notes_scale = notes_scale.notes if Scale === notes_scale
        return notes_for_string(notes_scale, tunning[string]) unless string.nil?
        
        raise "strings param should have a mark for each string" if !strings.nil? && strings.size != tunning.size
        chosen_strings = if strings.nil? then tunning else decode_strings(strings) end

        chosen_strings.map do |s|
            notes_for_string(notes_scale, s)
        end
    end

    def decode_strings(active_strings) 
        chosen_strings = []
        active_strings.each_with_index do |s, i|
            next if s == "x"
            chosen_strings << tunning[i]
        end
        chosen_strings
    end

    def notes_for_string(notes_scale, string)
        starting_pos = CHROMATIC_SCALE.index(string)
        notes = []
        @frets.times do |f|
            if notes_scale.include?(CHROMATIC_SCALE[(starting_pos+f)%12])
                notes << {note: CHROMATIC_SCALE[(starting_pos+f)%12], fret: f}
            end
        end
        notes
    end
end