require "dead_gems/version"

module DeadGems
  class << self
    def find_dead_gems(project_root, exerciser)
      logger = Logger.new($stdout)
      begin_dir = Dir.pwd
      change_directory_to project_root
      unused = find_all_gems.select do |gem|
        logger.debug(gem)
        gem_path = find_gem_path(gem)
        apply_environment_patch(gem_path) do
          run(exerciser)
        end
      end
    ensure
      change_directory_to begin_dir
    end

    private

    def change_directory_to(dir)
      Dir.chdir(dir)
    end

    def find_all_gems
      Bundler.with_clean_env do
        gem_lines = File.read('Gemfile.lock').split("DEPENDENCIES\n").last
        arr = []
        gem_lines.each_line { |line| arr << line.match(/\s*(\S+)/).captures.first }
        arr
      end
    end

    def find_gem_path(gem)
      Bundler.with_clean_env do
        `bundle list #{gem}`.chomp
      end
    end

    def apply_environment_patch(gem_path)
      file = 'test/test_helper.rb'
      prepatch = File.read(file)
      patch = <<-END
gem_path = '#{gem_path}'
trace = TracePoint.new(:call) do |tp|
  # Gem is used
  # Fail if any of the modules are called
  if tp.path.include?(gem_path)
    puts "Gem used: \#{tp.defined_class} called with \#{tp.method_id} in \#{tp.path}"
    exit(1)
  end
end
trace.enable
      END
      File.open(file, 'w') { |f| f.write([prepatch, patch].join("\n")) }
      yield
    ensure
      File.open(file, 'w') { |f| f.write(prepatch) }
    end

    def run(exerciser)
      res = Bundler.with_clean_env do
        # If all tests pass then the gem is unused.
        # Otherwise it would've have exited on-call.
        system exerciser
      end
    end
  end
end
