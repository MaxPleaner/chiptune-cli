require 'bloops' # the bloops o' phone
require 'active_support/inflector'
require 'byebug'

class BloopApi

  def initialize(options={})
    options = {
      tempo: 320,
    }.merge(options)
    @bloops = Bloops.new
    @bloops.tempo = options[:tempo]
  end

  def self.flow(options={})
    options = {
      length: 4,
      intensity_max: 5,
      intensity_min: 0,
    }.merge(options)
    options[:length].times {
      self.new.play_melody(
        intensity: [rand(options[:intensity_max]), options[:intensity_min]].max
      )
    }
  end

  def play_melody(options={})
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
    self.send([:base_tone, :chord_tone, :lead_tone].sample)
  end

  def new_rhythm_sound
    self.send([:bass_drum, :snare_drum].sample)
  end

  def rhythms
    [
      "A d6 d6 d6 B d6 d6 d6 A d6 d6 d6 sB d6 d6 d6",
      "4   c6 4  b5 4  4  e4 4   c6 4  b5 4  4  e4",
      "4 4a2 4 4a2 4 4a2 4 8a2 8a2",
      "4a2 4 4 4a2 4 4 4a2 4 4 4a2 4 4 ",
      "8 4a1 8a 8a 4a 4a 4c2 9c 7c 4c 8e",
      "8 4g2 8g 8 4g 4g 4d2 8 8c3 4b2 8e",
      "8 4d2 8c 8c 4c 4 4a2 9a 7a 4a 8a",
      "8 4g2 8g 8 4g 4d 4d2 9e3 7c2 8 4b1",
    ]
  end

  def melodies
    [
      " 32 + C E F# 8:A G E C - 8:A 8:F# 8:F# 8:F# 2:G",
    "f#5 c6 e4 b6 g5 d6 4  f#5 e5 c5 b6 c6 d6 4 ",
    "1a2 2a3 2 1d2 4g3 4g2 2e3",
    "1a2 2a3 2 1g2 2d3 2",
    "2g3 1a4 2 2g3 1a4 2",
    "2c5 1e4 2 1 2c5 1e4 2 1",
    "1a4 2 4 2e4 1d4 2",
    "2a3 1b4 2 2a3 1b4 2",
    "2d5 2g4 1c5 2d5 2g4 1c5",
    "1a4 1e5 1a4 1e5",
    "1b4 2 4 8 8d4 1b4 2 4 8 8d4 1b4 2 4 8 8d4    ",

    ]
  end

  def bass_drum
    @bloops.sound(Bloops::SQUARE).tap do |bass|
      bass.volume = 0.4
      bass.sustain = 0.1
      bass.attack = 0.1
      bass.decay = 0.3
    end
  end

  def base_tone
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

  def lead_tone
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