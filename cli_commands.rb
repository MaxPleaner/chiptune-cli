require_relative "bloop_api.rb"
require 'parallel'

BASE_TEMPO = 90

class Commands
  def initialize(options={})
    # make sure this method accepts a hash argument, which is passed from OptionParser
    puts "try 'help'".yellow
  end

  def odd_time(options={})
    # options: tempo, beat_count, repetitions
    BloopApi.odd_time(
      tempo: options[:tempo] || BASE_TEMPO,
      beat_count: options[:beat_count],
      repetitions: options[:repetitions] || 2,
      # solo: :rhythm,
    )
  end

  def polyrhythm
    Parallel.each(["flow", "odd_time"]) do |cmd|
      BloopApi.send(cmd.to_sym)
    end
  end

  def play_chiptune
    BloopApi.flow(
      tempo: BASE_TEMPO,
      length: 2,
      intensity_min: 1,
      intensity_max: 1,
    )
  end
  def parallel_chiptune(count)
    begin
      Parallel.each(count.times.to_a) { play_chiptune }
    rescue StandardError => e
      puts e.message
      puts "your computer cant handle it".red
    end
  end  
  def sick_beat(count=4)
    BloopApi.sick_beat(
      length: count, 
      intensity_min: 8,
      intensity_max: 8
    )
  end
  def parallel_sick_beat(count)
    begin
      Parallel.each(count.times.to_a) { play_chiptune }
    rescue StandardError => e
      puts e.message
      puts "your computer cant handle it".red
    end
  end  
  
end