require_relative "bloop_api.rb"
require 'parallel'

class Commands
  def initialize(options={})
    # make sure this method accepts a hash argument, which is passed from OptionParser
    puts "try 'help'".yellow
  end
  def play_chiptune
    BloopApi.flow(
      length: 8,
      intensity_max: 1,
      intensity_min: 1
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
end