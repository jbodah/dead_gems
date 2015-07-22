require "dead_gems/version"

module DeadGems
  class << self
    def find_dead_gems(project_root, exerciser)
      logger = Logger.new($stdout)
      change_directory_to project_root
      unused = find_all_gems.select do |gem|
        logger.debug(gem)
        loaded_modules = find_loaded_modules(gem)
        if loaded_modules.empty?
          logger.debug("Can't find analyzable modules for #{gem}")
          next
        end
        logger.debug(loaded_modules)
        apply_environment_patch(loaded_modules) do
          run(exerciser)
        end
      end
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

    # TODO maybe load ALL other gems then load this gem and see what it provides that others dont
    def find_loaded_modules(gem)
      # TODO silence errors
      Bundler.with_clean_env do
        `bundle exec ruby -e "pre = ObjectSpace.each_object(Module).to_set;
                              require '#{gem}';
                              post = ObjectSpace.each_object(Module).to_set;
                              puts (post - pre).to_a"`.split("\n")
      end
    end

    def apply_environment_patch(modules)
      file = 'test/test_helper.rb'
      prepatch = File.read(file)
      patch = <<-END
modules = #{modules}.to_set
trace = TracePoint.new(:call) do |tp|
  # Gem is used
  # Fail if any of the modules are called
  if modules.include?(tp.defined_class.to_s)
    puts "Gem used: \#{tp.defined_class} called with \#{tp.method_id}"
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
