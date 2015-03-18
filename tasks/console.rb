class RakeConsole
  GEM = Dir["*.gemspec"].first.sub('.gemspec', '')
  REQUIRE_PATH = File.join(Dir.pwd, 'lib', GEM)

  module Helpers
    def reload!
      puts "Reloading..."
      $LOADED_FEATURES.select do |feat|
        feat =~ /\/#{GEM}\//
      end.each { |file| load file }
      true
    end
  end

  def start
    require REQUIRE_PATH
    ARGV.clear
    Object.include(Helpers)

    begin
      require 'pry'
      TOPLEVEL_BINDING.pry
    rescue LoadError
      require 'irb'
      require 'irb/completion'
      IRB.start
    end
  end
end

desc "Start development console"
task :console do
  RakeConsole.new.start
end

