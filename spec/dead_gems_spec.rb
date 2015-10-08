require 'spec_helper'

class DeadGemsSpec < Minitest::Spec
  describe '.find' do
    describe 'given the dummy app and the test shell command' do
      before do
        @project_path = File.expand_path('../../dummy', __FILE__)
        @exerciser_command = 'bundle exec rake &> /dev/null'
      end

      it 'outputs factory_girl in the list of unused gems' do
        assert DeadGems.find(@project_path, @exerciser_command).include?('factory_girl')
      end

      it 'doesnt output timecop in the list of unused gems' do
        r = DeadGems.find(@project_path, @exerciser_command)
        assert !r.include?('timecop')
      end
    end
  end

  describe '.find_all_gems' do
    it 'correctly parses the example lock files' do
      Dir['spec/fixtures/lock_file*'].each do |path|
        begin
          str = File.read(path)

          original = File.method(:read)
          File.define_singleton_method(:read, -> (f) { str })
          DeadGems.send(:find_all_gems)
        ensure
          File.define_singleton_method(:read, original)
        end
      end
    end

    it 'correctly parses outs bangs' do
      begin
        str = <<-FILE
DEPENDENCIES
  test!
FILE

        original = File.method(:read)
        File.define_singleton_method(:read, -> (f) { str })
        assert DeadGems.send(:find_all_gems).any? {|g| g == 'test'}
      ensure
        File.define_singleton_method(:read, original)
      end
    end
  end
end
