An interactive CLI for using [bloopsaphone](https://github.com/mental/bloopsaphone),
a chiptune sound creator for Ruby.

Bloopsaphone can be hard to install, I had to install a sequence of 3 dependencies
I think. Just google the errors. 

This uses my [ruby-cli-skeleton](http://github.com/maxpleaner/ruby-cli-skeleton)
template for a REPL / CLI.

The chiptune-related CLI commands are in `cli_commands.rb`.
At present there is only one command here, it is `play_chiptune`
and it plays randomly-generated chiptune music for 16 bars. 
It calls `BloopApi.flow` with a few options. `length` is the number of bars to play,
and `intensity_max` and `intensity_min` are used to control the number of
instruments playing concurrently. In `flow`, a random number between the intensity
bounds is used to determine the number of instruments concurrently playing for that bar.
For each instrument, a random sound is chosen and paired with a random melody / rhythm.

See `bloop_api.rb` for the bloop API helpers.