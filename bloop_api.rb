require 'bloops' # the bloops o' phone
require 'active_support/inflector'
require 'byebug'

BASE_TEMPO = 90

class OddTimePhrase 
  attr_accessor :odd_time_sequence, :min, :max
  def self.random
    time_pairs = [
      [3, 32], [5, 32], [7, 32], [9, 32]
    ]
    return self.new(*time_pairs.sample)
  end
  def initialize(time1, time2)
    @max, @min = [time1, time2].max, [time1, time2].min
    @odd_time_sequence = [
      Array.new((max / min), min), # play min N times
      (max % min)                  # the leftover amount 
    ].flatten
  end
end

class BloopApi
  # usage:
    # Class methods:
      # BloopApi.flow -------------------- Play random beats
      # BloopApi.sick_beat --------------- Play sick beat
      # BloopApi.odd_time ---------------- Generate a polythythm
      # BloopApi.odd_rhythm_riff --------- Rhythm riff of (n) length, supports: [3, 5, 6, 7, 9]
      # BloopApi.odd_melody_riff --------- Melody riff of (n) length, supports: [3, 5, 6, 7, 9]
      # BloopApi.standard_rhythm_riff ---- Rhythm riff of (n) length, supports multiples of 4
      # BloopApi.standard_melody_riff ---- Melody riff of (n) length, supports multiples of 4
    # Instance methods:
      # BloopApi.new.play_sick_beat ------ Play sick beat base
      #              generate_riff ------- Play riff
      #              new_melody_sound ---- Random melody instrument
      #              new_rhythm_sound ---- Random rhythm instrument
      #              rhythms ------------- Rhythm riffs
      #              melodies ------------ Melody riffs
      #              bass_tone ----------- Bass tone instrument
      #              bass_drum ----------- Bass drum instrument
      #              snare_drum ---------- Snare drum instrument
      #              chord_tone ---------- Chord tone instrument
      #              hand_drum ----------- Hand drum instrument

  attr_reader :bloops
  def initialize(options={})
    # create a Bloop instance
    # options: tempo
    options = {
      tempo: BASE_TEMPO,
    }.merge(options.reject { |k, v| v.nil?})
    @bloops = Bloops.new
    @bloops.tempo = options[:tempo]
  end

  def self.odd_rhythm_riff(num_beats, mixed=false, idx=nil)
    num_beats = num_beats.to_s
    riffs = {
      "2" => [
       "- - 16A 16" 
      ],
      "4" => [
        "- - 16A 16 + 16C - 16"
      ],
      "3" => [
        "- - 16A 16A + 16C",
      ],
      "5" => [
        "- - 16A 16 16A 16 16",
      ],
      "6" => [
        "- - 16A 16A + 16C - 16A 16A + 16C"
      ],
      "7" => [
        "- - 16A 16 16A 16 + 16C - 16 16",
      ],
      "8" => [
        "16A 16C 16C 16C 16C 16C 16C 16C"
      ],
      "9" => [
        "- - 16A 16 16 16A 16 16 16A 16A 16A",

      ]
    }
    begin
    return mixed ? riffs[num_beats].sample : riffs[num_beats][idx || 0]
  rescue StandardError; byebug; end
  end

  def self.odd_melody_riff(num_beats, mixed=false, idx=nil)
    num_beats = num_beats.to_s
    riffs = {
      "2" => [
       "- 16A 16" 
      ],
      "4" => [
        "- 16A 16 + 16C - 16"
      ],
      "3" => [
        "- 16A 16A + 16C",
      ],
      "5" => [
        "- 16A 16 16A 16 16",
      ],
      "6" => [
        "- 16A 16A + 16C - 16A 16A + 16C"
      ],
      "7" => [
        "- 16A 16 16A 16 + 16C - 16 16",
      ],
      "8" => [
        "16A 16C 16C 16C 16C 16C 16C 16C"
      ],
      "9" => [
        "- 16A 16 16 16A 16 16 16A 16A 16A",

      ]
    }
    (return mixed ? riffs[num_beats].sample : riffs[num_beats][idx || 0]) rescue byebug
  end

  def self.standard_rhythm_riff(length, mixed=false, idx=nil)
    # combines 8 note riffs to fit the desired result.
    # enter 'mixed' option to switch them up
    riffs = [
      " 16D 16 16C 16 16D 16 16C 16",
      "16D 16 16 16 16D 16 16 16 ",
      " 16 16 16 16 16D 16 16 16"
    ]
    res = []
    until (res.length * 8) == length
      res << mixed ? riffs.sample : riffs[idx || 0]
    end
    return res.join(" ")
  end

  def self.standard_melody_riff(length, mixed=false, idx=nil)
    # combines 8 note riffs to fit the desired result.
    # enter 'mixed' option to switch them up
    riffs = [
      "16B 16A 16A 16A 16B 16A 16A 16A",
      "16 16 16 16A 16A 16B 16B 16B",
      "16 16 16 16A 16A 16 16B 16B",
    ]
    res = []
    until (res.length * 8) == length
      res << mixed ? riffs.sample : riffs[idx || 0]
    end
    return res.join(" ")
  end

  # options: tempo, beat_count, repetitions, solo
  # tempo:       bpm
  # beat_count:  [ odd_count, container_count] i.e. [5, 32]
  # repetitions: play the whole thing N times
  # solo:        either :melody or :rhythm, if only one should be odd
  def self.odd_time(options={})
      tempo = options[:tempo]
      solo = options[:solo]
    # init odd time counts for entire phrase
      if options[:beat_counts]
        sequence = OddTimePhrase.new(*options[:beat_counts])
      else
        sequence = OddTimePhrase.random
      end
      min = sequence.min
      max = sequence.max
      puts "#{"odd time sequence".blue}: #{sequence.odd_time_sequence.join(", ").green}"
      (options[:repetitions] || 4).times do
        sequence.odd_time_sequence.each do |beats_count|
          bloop = BloopApi.new(tempo: tempo || BASE_TEMPO)
          bloop.bloops.tune(bloop.bass_drum, BloopApi.odd_rhythm_riff(beats_count)) unless solo == :melody
          bloop.bloops.tune(bloop.bass_tone, BloopApi.odd_melody_riff(beats_count)) unless solo == :rhythm
          bloop.bloops.play
          puts "playing #{beats_count}"
          sleep 0.1 while !bloop.bloops.stopped?
        end
      end 

      # How to play this in parallel?
      #     # standard time sequence
      #       bloop = BloopApi.new(tempo: tempo || 500)
      #       puts tempo || 500
      #       bloop.bloops.tune(bloop.new_rhythm_sound, BloopApi.standard_rhythm_riff(max)) unless solo == :rhythm
      #       bloop.bloops.tune(bloop.new_melody_sound, BloopApi.standard_melody_riff(max)) unless solo == :melody
      #       puts "playing #{max}"
      #       bloop.bloops.play
      #       sleep 0.1 while !bloop.bloops.stopped?
      #   }
  end
    
            #   Parallel.each([1,2]) do |idx|
            #     sequence.odd_time_sequence.each do |beats_count|
            #         bloop = self.new(tempo: options[:tempo])
            #         bloop.tune(new_rhythm_sound, odd_rhythm_riff(sequence.min))
            #         bloop.tune(new_melody_sound, odd_melody_riff(sequence.min))
            #         bloop.play
            #       end
            #   end

            #   bloops[0].tune(new_rhythm_sound, odd_rhythm_riff(min))
            #   bloops[0].tune(new_melody_sound, odd_melody_riff(min))
            #   bloops.each { |bloop| bloop.play }
            #   sleep 0.5 while (!(bloops.all { |bloop| bloop.stopped? }))
            # end

  def self.flow(options={})
    # play random riffs
    # options: length, intensity_max, intensity_min
    # intensity here referrers to the number of instruments played
    # a random number in the bounds is used for each phrase
    options = {
      length: 4,
      intensity_max: 1,
      intensity_min: 1,
    }.merge(options)
    options[:length].times {
      self.new.generate_riff(
        intensity: [rand(options[:intensity_max]), options[:intensity_min]].max
      )
    }
  end

  def self.sick_beat(options={})
    # plays a 'sick beat' with variable intensity
    # options: length, intensity_min, intensity_max, tempo
    # intensity here referrers to loudness (track stacking)
    # a random number in the bounds is used for each phrase
    options = {
      length: 4,
      intensity_min: 2,
      intensity_max: 3,
      tempo: 320,
    }.merge(options)
    options[:length].times {
      self.new(tempo: options[:tempo]).play_sick_beat(
        intensity: [rand(options[:intensity_max]), options[:intensity_min]].max
      )
    }
  end

  def play_sick_beat(options={})
    # plays a single phrase of 'sick beat'
    # options: intensity (num of concurrent tracks i.e. loudness)
    options = {
      intensity: 1
    }.merge(options)
    bass_riff = "- D 4 4 D 4 4 D 4 4 4 D 4 4 4 4 4"
    snare_riff = "- 4 4 4 4 D 4 4 4 4 4 4 4 D 4 4 4 "
    hand_riff = "4 D D 4 4 D 4 D D D 4 D 4 D D D"
    melody_riff = "- - - - 1A 1A 1A 2A 2E"
    [0, options[:intensity]].max.times {
      melody = new_melody_sound
      @bloops.tune(bass_drum, bass_riff)
      @bloops.tune(snare_drum, snare_riff)
      @bloops.tune(hand_drum, hand_riff)
      @bloops.tune(melody, melody_riff)
      @bloops.play
    }
    sleep 0.05 while !@bloops.stopped?
  end

  def generate_riff(options={})
    # play a single measure with random instruments and melody
    # options: intensity (num concurrent tracks)
    options = {
      intensity: 1
    }.merge(options)
    [0, options[:intensity]].max.times {
      melody = new_melody_sound
      rhythm = new_rhythm_sound
      @bloops.tune(rhythm, rhythms.sample)
      @bloops.tune(melody, melodies.sample)
      @bloops.play
    }
    sleep 0.05 while !@bloops.stopped?
  end

  def new_melody_sound
    # random sound out of the 'melodies'
    self.send([:bass_tone, :chord_tone].sample)
  end

  def new_rhythm_sound
    # random sound out of the 'rhythms'
    self.send([:bass_drum, :snare_drum, :hand_drum].sample)
  end

  def rhythms
    # rhythm phrases
    [
      " - 8B 8 + 8A - 8 8B 8 + 8A - 8 8B 8 + 8A - 8 8B 8 + 8A - 8"
    ]
  end

  def melodies
    # melody phrases
    [
      " - 8B 8 + 8A -  8 8B 8 + 8A - 8 8B 8 + 8A - 8 8B 8 + 8A - 8"
      # " - - - 16F# 16B 16E 16C#",
      # "- - 16D 16D - 16A# - 16C",

      # "D# 4 2 D# 4 2 D# 4 2 D# 4 2",
      # "1 1 1 1 D# D# D# D# ",
      # "1D# 1F# 1D# 1F#",
      # "B C F# 16 D",
      # " C D D# B"
    ]
  end

  def bass_tone
    # melody instrument
    @bloops.sound(Bloops::SQUARE).tap do |bass|
      bass.volume = 0.4
      bass.sustain = 0.1
      bass.attack = 0.1
      bass.decay = 0.3
    end
  end

  def bass_drum
    # rhythm instrument    
    @bloops.sound(Bloops::SQUARE).tap do |base|
      base.volume = 0.35
      base.punch = 0.3
      base.sustain = 0.1
      base.decay = 0.3
      base.phase = 0.2
      base.lpf = 0.115
      base.resonance = 0.55
      base.slide = -0.4
    end
  end

  def snare_drum
    # rhythm instrument    
    @bloops.sound(Bloops::SQUARE).tap do |snare|
      snare.attack = 0.075
      snare.sustain = 0.01
      snare.decay = 0.33
      snare.hpf = 0.55
      snare.resonance = 0.44
      snare.dslide = -0.452
    end
  end

  def chord_tone
    # melody instrument    
    @bloops.sound(Bloops::SQUARE).tap do |chord|
      chord.volume = 0.275
      chord.attack = 0.05
      chord.sustain = 0.6
      chord.decay = 0.9
      chord.phase = 0.35
      chord.psweep = -0.25
      chord.vibe = 0.0455
      chord.vspeed = 0.255
    end
  end

  def hand_drum
    # rhythm instrument    
    @bloops.sound(Bloops::SINE).tap do |lead|
      lead.volume = 0.45
      lead.attack = 0.3
      lead.sustain = 0.15
      lead.decay = 0.8
      lead.vibe = 0.035
      lead.vspeed = 0.345
      lead.vdelay = -0.5
      lead.hpf = 0.2
      lead.hsweep = -0.05
      lead.resonance = 0.55
      lead.phase = 0.4
      lead.psweep = -0.05
    end
  end

end