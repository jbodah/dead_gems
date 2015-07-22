ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

gem_paths = ["/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/coffee-rails-4.0.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/factory_girl-4.4.0", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/jbuilder-2.3.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/jquery-rails-3.1.3", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/rails-4.1.5", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sass-rails-4.0.5", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sdoc-0.4.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/spring-1.3.6", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.10", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/timecop-0.5.4", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/turbolinks-2.5.3", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/uglifier-2.7.1"]
trace = TracePoint.new(:call) do |tp|
  # Gem is used
  # Print to file
  if path = gem_paths.detect {|p| tp.path.include?(p)}
    puts "Gem used: #{tp.defined_class} called with #{tp.method_id} in #{tp.path}"
    File.open('dead_gems.out', 'a') {|f| f.write path}
    gem_paths.delete(path)
  end
end
trace.enable

gem_paths = ["/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/coffee-rails-4.0.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/factory_girl-4.4.0", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/jbuilder-2.3.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/jquery-rails-3.1.3", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/rails-4.1.5", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sass-rails-4.0.5", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sdoc-0.4.1", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/spring-1.3.6", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/sqlite3-1.3.10", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/timecop-0.5.4", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/turbolinks-2.5.3", "/Users/jbodah/.rbenv/versions/2.1.3/lib/ruby/gems/2.1.0/gems/uglifier-2.7.1"]
trace = TracePoint.new(:call) do |tp|
  # Gem is used
  # Print to file
  if path = gem_paths.detect {|p| tp.path.include?(p)}
    puts "Gem used: #{tp.defined_class} called with #{tp.method_id} in #{tp.path}"
    File.open('dead_gems.out', 'a') {|f| f.puts path}
    gem_paths.delete(path)
  end
end
trace.enable
