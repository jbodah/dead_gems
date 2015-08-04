# DeadGems

[![Gem Version](https://badge.fury.io/rb/dead_gems.svg)](http://badge.fury.io/rb/dead_gems)
[![Build Status](https://travis-ci.org/jbodah/dead_gems.svg)](https://travis-ci.org/jbodah/dead_gems)

lists your app's unused gems

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

**NOTE** This will take a long time as it uses [TracePoint](http://ruby-doc.org/core-2.0.0/TracePoint.html) to check the source location of every method call to see if the code being leveraged is in a gem directory.

```rb
# First make sure to backup any changes you have (e.g. commit them to git, stash them, etc)
$ irb
$ irb(main)> require 'dead_gems'
$ irb(main)> DeadGems.find('~/my_slow_project', 'bundle exec rake test') 
```

This will run my project's tests and output all of the gems that aren't used in my tests.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/dead_gems/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
