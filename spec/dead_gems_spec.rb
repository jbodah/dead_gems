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
end
