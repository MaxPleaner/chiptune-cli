An interactive CLI for using [bloopsaphone](https://github.com/mental/bloopsaphone),
a chiptune sound creator for Ruby.

Look in the `ruby-cli-skeleton` file for the Gemfile used for this app.

The `bloopsaphone` gem can be hard to install, I had to install a sequence of 3 dependencies
I think. Just google the errors. 

This uses my [ruby-cli-skeleton](http://github.com/maxpleaner/ruby-cli-skeleton)
template for a REPL / CLI.

The chiptune-related CLI commands are in `cli_commands.rb`.
At present there are tw command here, `play_chiptune` and `parallel_chiptune`.

They play randomly-generated chiptune music for a few bars.

### `play_chiptune`

This produces a call `BloopApi.flow`.

`BloopApi.flow` lives in `bloop_api.rb`. The `flow` method takes a few options"

- `length` is the number of bars to play,
- `intensity_max` and `intensity_min` are used to control the number of
instruments playing concurrently.

A random number between the intensity bounds is used to determine
the number of instruments concurrently playing for that bar.

For each instrument, a random sound is chosen and paired with a random melody / rhythm.

### `parallel_chiptune(thread_count)`

This uses the [parallel](https://github.com/grosser/parallel) ruby gem to run the
`play_chiptune` command multiple times in parallel.

The 'intensity' options in `BloopApi.flow` also plays parallel sounds.

This is just experiments in how to get the best performance.

There are limits on the number of parallel threads. When 'intensity' is high,
fewer `parallel` threads can be used.
