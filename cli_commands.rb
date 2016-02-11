require_relative "bloop_api.rb"

class Commands
  def initialize(options={})
    # make sure this method accepts a hash argument, which is passed from OptionParser
    puts "try 'help'".yellow
  end
  def play_chiptune
    BloopApi.flow(
      length: 16,
      intensity_max: 10,
      intensity_min: 5
    )
  end
end