require "dead_gems/version"
require "logger"
require "bundler"

module DeadGems
  GemInstance = Struct.new(:name, :path)

  class << self
    def find(project_root, exerciser)
      begin_dir = Dir.pwd
      logger = Logger.new($stdout)
      change_directory_to project_root
      gems = find_all_gems.map do |name|
        path = find_gem_path(name)
        GemInstance.new(name, path)
      end
      apply_environment_patch(gems) do
        run(exerciser, gems)
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
        gem_lines.each_line { |line| arr << line.match(/\s*([^\s!]+)/).captures.first }
        arr
      end
    end

    def find_gem_path(gem)
      Bundler.with_clean_env do
        `bundle list #{gem}`.chomp
      end
    end

    def apply_environment_patch(gems)
      file = 'test/test_helper.rb'
      prepatch = File.read(file)
      patch = <<-END
gem_paths = #{gems.map(&:path)}
trace = TracePoint.new(:call) do |tp|
  # Gem is used
  # Print to file
  if path = gem_paths.detect {|p| tp.path.include?(p)}
    puts "Gem used: \#{tp.defined_class} called with \#{tp.method_id} in \#{tp.path}"
    File.open('dead_gems.out', 'a') {|f| f.puts path}
    gem_paths.delete(path)
  end
end
trace.enable
      END
      File.open(file, 'w') { |f| f.write([prepatch, patch].join("\n")) }
      yield
    ensure
      File.open(file, 'w') { |f| f.write(prepatch) }
      File.delete('dead_gems.out') if File.exists?('dead_gems.out')
    end

    def run(exerciser, gems)
      Bundler.with_clean_env do
        # If all tests pass then the gem is unused.
        # Otherwise it would've have exited on-call.
        system exerciser
        File.read('dead_gems.out').each_line do |line|
          path = line.chomp
          gems.delete_if {|g| g.path == path}
        end
        gems.map(&:name)
      end
    end
  end
end
