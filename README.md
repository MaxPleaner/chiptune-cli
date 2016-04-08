**An interactive CLI for using [bloopsaphone](https://github.com/mental/bloopsaphone),
a chiptune sound creator Ruby gem.**

### Usage

1. `bundle` - _the bloopsaphone gem will probably fail at first because of missing system dependencies. I got it installed on Ruby 2.4 by googling the errors._

2. `./start_cli`

3. `help`

4. _enter a command of your choice_

### About

**CLI application structure**

This uses my [ruby-cli-skeleton](http://github.com/maxpleaner/ruby-cli-skeleton)
template for a REPL / CLI.

The chiptune-related CLI commands are in `cli_commands.rb`.

The underlying music-playing API is in `bloop_api.rb`. 

### Warning

High likelihood of alsa/pulseaudio errors, especially when you playing a lot of sounds quickly or at the same time. Exiting and restarting the CLI is a temporary fix but this is still very low-performance software. 

### Commands

1. `odd_time(options={})`
  - _plays a polyrhythm_ in a simple structure inspired by Meshuggah. See [here](https://societymusictheory.org/files/2014_handouts/capuzzo.pdf) for an in-depth explanation or [here](http://metalintheory.com/meshuggah-obzen/) for a more simplified explanation, 
  - option keys(symbols):
    1. tempo (i.e. BPM), defaults to 90,
    2. beat_count (i.e. [4,17] or [3, 123]), the two beat counts which define the polythythm). Defaults to a random pair 
    3. repetitions (i.e. total length / phrase length), defaults to 2
  - **bonus** shows some rudimentary visualizer art in the console

2. `polyrhythm`
  - calls the `odd_time` and `play_chiptune` commands in parallel.
  - this has the effect of adding a 4/4 backing beat to the odd time melody. 

3. `play_chiptune`
  - Plays a very simple 4/4 beat / melody. Probably doesn't sound that great.
  - option keys(symbols):
    1. tempo (defaults to 240)
    2. length (defaults to 8)
    3. intensity_min (defaults to 2), the minimum number of instruments playing at once
    4. intensity_max (defaults to 3), the maximum number of instruments playing at once. 

4. `sick_beat(count=4)`
  - Plays a hip-hop beat.
  - Some friendly glitching can be expected.

5. `parallel_sick_beat(count)`
  - plays too much annoying noise


