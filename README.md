# DeadGems

lists the unused gems in your application

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dead_gems'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dead_gems

## Usage

`DeadGems::find` is the main entry point. It takes the path to your project's root (which should contain your Gemfile) and a shell command to use in that project that should touch as much of your code as possible.

```
$ irb
$ irb(main)> require 'dead_gems'
$ irb(main)> DeadGems.find('~/my_slow_project', 'bundle exec rake test') 
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dead_gems/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
