require_relative "bloop_api.rb"
require 'parallel'

class Commands
  def initialize(options={})
    # make sure this method accepts a hash argument, which is passed from OptionParser
    puts "try 'help'".yellow
  end
  def odd_time(options={})
    # options: tempo, beat_count, repetitions
    BloopApi.odd_time(
      tempo: options[:tempo] || 100,
      beat_count: options[:beat_count],
      repetitions: options[:repetitions] || 4,
      # solo: :rhythm,
    )
  end

  def play_chiptune
    BloopApi.flow(
      length: 16,
      intensity_min: 10,
      intensity_max: 18,
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