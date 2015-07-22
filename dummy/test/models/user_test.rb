require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "user time" do
    assert !User.new.time.nil?
  end
end
