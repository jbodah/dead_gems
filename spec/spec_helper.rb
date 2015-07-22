lib = File.expand_path('../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dead_gems'
require 'minitest/autorun'
require 'minitest/pride'
require 'minitest/spec'
